sealed class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends ApiException {
  const NetworkException({
    required super.message,
    super.statusCode,
    super.data,
  });
}

class AuthException extends ApiException {
  const AuthException({
    required super.message,
    super.statusCode,
    super.data,
  });
}

class ServerException extends ApiException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.data,
  });
}

class CacheException extends ApiException {
  const CacheException({
    required super.message,
    super.data,
  }) : super(statusCode: null);
}

class ValidationException extends ApiException {
  const ValidationException({
    required super.message,
    super.data,
  }) : super(statusCode: 422);
}

class AiServiceException extends ApiException {
  const AiServiceException({
    required super.message,
    super.statusCode,
    super.data,
  });
}
