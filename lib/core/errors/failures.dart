enum FailureType { network, server, auth, validation, parsing, timeout, cancel, unknown }

class Failure {
  final String message;
  final FailureType type;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.type = FailureType.unknown,
    this.originalError,
    this.stackTrace,
  });

  /// Formats the failure into a user-friendly, localized message.
  String toMessage() => message;

  @override
  String toString() => toMessage();

  bool get isConnectionError =>
      type == FailureType.network || type == FailureType.timeout;
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'تعذر الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت',
    super.type = FailureType.network,
    super.originalError,
    super.stackTrace,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'انتهت مهلة الاتصال بالخادم. يرجى المحاولة مرة أخرى',
    super.type = FailureType.timeout,
    super.originalError,
    super.stackTrace,
  });
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    this.statusCode,
    super.type = FailureType.server,
    super.originalError,
    super.stackTrace,
  });
}

class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.type = FailureType.auth,
    super.originalError,
    super.stackTrace,
  });
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? validationErrors;

  const ValidationFailure({
    required super.message,
    this.validationErrors,
    super.type = FailureType.validation,
    super.originalError,
    super.stackTrace,
  });
}

class ParsingFailure extends Failure {
  const ParsingFailure({
    super.message = 'حدث خطأ أثناء معالجة بيانات الاستجابة من الخادم',
    super.type = FailureType.parsing,
    super.originalError,
    super.stackTrace,
  });
}

class CancelFailure extends Failure {
  const CancelFailure({
    super.message = 'تم إلغاء الطلب بنجاح',
    super.type = FailureType.cancel,
    super.originalError,
    super.stackTrace,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً',
    super.type = FailureType.unknown,
    super.originalError,
    super.stackTrace,
  });
}
