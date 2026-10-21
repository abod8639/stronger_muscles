class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ServerException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({
    this.message = 'تعذر الاتصال بالشبكة. يرجى التأكد من اتصالك بالإنترنت',
  });

  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;

  const AuthException({required this.message});

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;

  const ValidationException({
    required this.message,
    this.errors,
  });

  @override
  String toString() => message;
}

class ParsingException implements Exception {
  final String message;
  final dynamic originalError;

  const ParsingException({
    this.message = 'حدث خطأ في قراءة ومعالجة البيانات',
    this.originalError,
  });

  @override
  String toString() => message;
}

class TimeoutAppException implements Exception {
  final String message;

  const TimeoutAppException({
    this.message = 'انتهت مهلة انتظار استجابة الخادم',
  });

  @override
  String toString() => message;
}

class CancelAppException implements Exception {
  final String message;

  const CancelAppException({
    this.message = 'تم إلغاء العملية',
  });

  @override
  String toString() => message;
}
