import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../network/api_exception.dart';
import 'failure.dart';

class ErrorHandler {
  ErrorHandler._();

  static Failure mapException(Exception exception) {
    developer.log('ErrorHandler: $exception', name: 'ErrorHandler');

    if (exception is ApiException) {
      return _mapApiException(exception);
    }

    if (exception is DioException) {
      return _mapDioException(exception);
    }

    if (exception is supabase.AuthException) {
      return AuthFailure(message: exception.message);
    }

    if (exception is supabase.PostgrestException) {
      return ServerFailure(
        message: exception.message,
        statusCode: exception.code != null ? int.tryParse(exception.code!) : null,
      );
    }

    return ServerFailure(message: exception.toString());
  }

  static Failure _mapApiException(ApiException exception) {
    return switch (exception) {
      AuthException() => AuthFailure(message: exception.message),
      NetworkException() => NetworkFailure(
          message: exception.message,
          statusCode: exception.statusCode,
        ),
      ServerException() => ServerFailure(
          message: exception.message,
          statusCode: exception.statusCode,
        ),
      CacheException() => CacheFailure(message: exception.message),
      ValidationException() => ValidationFailure(message: exception.message),
      AiServiceException() => AiServiceFailure(message: exception.message),
    };
  }

  static Failure _mapDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(message: 'Connection timed out');
      case DioExceptionType.connectionError:
        return const NetworkFailure(message: 'No internet connection');
      case DioExceptionType.badResponse:
        final statusCode = exception.response?.statusCode;
        if (statusCode == 401) {
          return const AuthFailure(message: 'Authentication failed');
        }
        if (statusCode == 422) {
          return ValidationFailure(
            message: _extractMessage(exception.response?.data) ??
                'Validation failed',
          );
        }
        return ServerFailure(
          message: _extractMessage(exception.response?.data) ??
              'Server error occurred',
          statusCode: statusCode,
        );
      default:
        return ServerFailure(message: exception.message ?? 'Unknown error');
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data == null) return null;
    if (data is String) return data;
    if (data is Map) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          data['error_description']?.toString();
    }
    return data.toString();
  }

  /// Wraps an async call and maps any exception to a Failure.
  static Future<T> guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on Exception catch (e) {
      throw mapException(e);
    }
  }
}
