import 'dart:async';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'exceptions.dart';
import 'failures.dart';

/// Centralized error handler to map network, server, streaming, and runtime exceptions
/// into standardized [Failure] instances without duplicating catch blocks.
class NetworkErrorHandler {
  const NetworkErrorHandler._();

  /// Executes a given asynchronous network [call], safely wrapping any thrown
  /// exceptions into an [Either.left(Failure)] or returning [Either.right(T)].
  static Future<Either<Failure, T>> execute<T>(
    Future<T> Function() call,
  ) async {
    try {
      final result = await call();
      return Right(result);
    } catch (error, stackTrace) {
      final failure = handle(error, stackTrace);
      return Left(failure);
    }
  }

  /// Maps any caught [error] and optional [stackTrace] to a typed [Failure].
  static Failure handle(dynamic error, [StackTrace? stackTrace]) {
    if (error is Failure) {
      return error;
    }

    if (error is DioException) {
      return handleDioError(error, stackTrace);
    }

    if (error is ServerException) {
      return ServerFailure(
        message: error.message,
        statusCode: error.statusCode,
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is NetworkException) {
      return NetworkFailure(
        message: error.message,
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is AuthException) {
      return AuthFailure(
        message: error.message,
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is ValidationException) {
      return ValidationFailure(
        message: error.message,
        validationErrors: error.errors,
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is ParsingException) {
      return ParsingFailure(
        message: error.message,
        originalError: error.originalError ?? error,
        stackTrace: stackTrace,
      );
    }

    if (error is TimeoutAppException || error is TimeoutException) {
      return TimeoutFailure(
        message: 'انتهت مهلة الانتظار. يرجى إعادة المحاولة',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is CancelAppException) {
      return CancelFailure(
        message: error.message,
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is CacheException) {
      return CacheFailure(
        message: error.message,
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    return UnknownFailure(
      message: error is String ? error : 'حدث خطأ غير متوقع',
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Maps [DioException] to the appropriate [Failure] subtype.
  static Failure handleDioError(DioException e, [StackTrace? stackTrace]) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(
          message: 'انتهت مهلة الاتصال بالخادم. يرجى التحقق من سرعة الإنترنت',
          originalError: e,
          stackTrace: stackTrace,
        );

      case DioExceptionType.badResponse:
        final response = e.response;
        if (response != null) {
          return _handleHttpResponse(response, stackTrace);
        }
        return ServerFailure(
          message: 'استجابة غير صالحة من الخادم',
          originalError: e,
          stackTrace: stackTrace,
        );

      case DioExceptionType.cancel:
        return CancelFailure(
          message: 'تم إلغاء الطلب',
          originalError: e,
          stackTrace: stackTrace,
        );

      case DioExceptionType.connectionError:
        return NetworkFailure(
          message: 'تعذر الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت',
          originalError: e,
          stackTrace: stackTrace,
        );

      case DioExceptionType.badCertificate:
        return ServerFailure(
          message: 'خطأ في شهادة أمان الخادم',
          originalError: e,
          stackTrace: stackTrace,
        );

      case DioExceptionType.unknown:
      default:
        return NetworkFailure(
          message: 'خطأ في الاتصال بالشبكة، تأكد من الاتصال وأعد المحاولة',
          originalError: e,
          stackTrace: stackTrace,
        );
    }
  }

  /// Handles HTTP responses with error status codes (4xx, 5xx) with safe payload inspection.
  static Failure _handleHttpResponse(Response response, [StackTrace? stackTrace]) {
    final statusCode = response.statusCode ?? 500;
    final dynamic data = response.data;

    String? serverMessage;
    Map<String, dynamic>? validationErrors;

    if (data is Map) {
      serverMessage = data['message']?.toString() ?? data['error']?.toString();
      if (data['errors'] is Map) {
        validationErrors = Map<String, dynamic>.from(data['errors']);
      }
    } else if (data is String && data.isNotEmpty && !data.trim().startsWith('<')) {
      serverMessage = data;
    }

    if (statusCode == 401 || statusCode == 403) {
      final isLoginRoute = response.requestOptions.path.contains('login');
      final msg = serverMessage ??
          (isLoginRoute
              ? 'بيانات تسجيل الدخول غير صحيحة، يرجى التأكد والمحاولة مجدداً'
              : 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول من جديد');
      return AuthFailure(
        message: msg,
        originalError: response,
        stackTrace: stackTrace,
      );
    }

    if (statusCode == 422) {
      String validationMsg = 'بيانات المدخلات غير صالحة';
      if (validationErrors != null && validationErrors.isNotEmpty) {
        final List<String> errorLines = [];
        validationErrors.forEach((field, errors) {
          if (errors is List) {
            errorLines.addAll(errors.map((e) => e.toString()));
          } else if (errors != null) {
            errorLines.add(errors.toString());
          }
        });
        if (errorLines.isNotEmpty) {
          validationMsg = errorLines.join('\n');
        }
      } else if (serverMessage != null) {
        validationMsg = serverMessage;
      }

      return ValidationFailure(
        message: validationMsg,
        validationErrors: validationErrors,
        originalError: response,
        stackTrace: stackTrace,
      );
    }

    if (statusCode >= 500) {
      return ServerFailure(
        message: serverMessage ?? 'الخادم يواجه مشكلة مؤقتة. يرجى المحاولة لاحقاً ($statusCode)',
        statusCode: statusCode,
        originalError: response,
        stackTrace: stackTrace,
      );
    }

    return ServerFailure(
      message: serverMessage ?? 'حدث خطأ في معالجة الطلب ($statusCode)',
      statusCode: statusCode,
      originalError: response,
      stackTrace: stackTrace,
    );
  }
}
