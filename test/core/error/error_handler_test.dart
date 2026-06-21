import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:fitted/core/error/error_handler.dart';
import 'package:fitted/core/error/failure.dart';
import 'package:fitted/core/network/api_exception.dart';

void main() {
  group('ErrorHandler.mapException', () {
    test('maps AuthException (api) to AuthFailure', () {
      final failure = ErrorHandler.mapException(
        const AuthException(message: 'bad credentials'),
      );
      expect(failure, isA<AuthFailure>());
      expect(failure.message, 'bad credentials');
    });

    test('maps NetworkException to NetworkFailure with statusCode', () {
      final failure = ErrorHandler.mapException(
        const NetworkException(message: 'down', statusCode: 503),
      );
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).statusCode, 503);
    });

    test('maps ServerException to ServerFailure with statusCode', () {
      final failure = ErrorHandler.mapException(
        const ServerException(message: 'boom', statusCode: 500),
      );
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 500);
    });

    test('maps CacheException to CacheFailure', () {
      final failure = ErrorHandler.mapException(
        const CacheException(message: 'hive write failed'),
      );
      expect(failure, isA<CacheFailure>());
      expect(failure.message, 'hive write failed');
    });

    test('maps ValidationException to ValidationFailure', () {
      final failure = ErrorHandler.mapException(
        const ValidationException(message: 'invalid email'),
      );
      expect(failure, isA<ValidationFailure>());
      expect(failure.message, 'invalid email');
    });

    test('maps AiServiceException to AiServiceFailure', () {
      final failure = ErrorHandler.mapException(
        const AiServiceException(message: 'openai 429'),
      );
      expect(failure, isA<AiServiceFailure>());
      expect(failure.message, 'openai 429');
    });

    test('maps DioException connectionTimeout to NetworkFailure', () {
      final failure = ErrorHandler.mapException(
        DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: '/x'),
        ),
      );
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, 'Connection timed out');
    });

    test('maps DioException connectionError to NetworkFailure', () {
      final failure = ErrorHandler.mapException(
        DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: '/x'),
        ),
      );
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, 'No internet connection');
    });

    test('maps DioException badResponse 401 to AuthFailure', () {
      final failure = ErrorHandler.mapException(
        DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/x'),
          ),
          requestOptions: RequestOptions(path: '/x'),
        ),
      );
      expect(failure, isA<AuthFailure>());
      expect(failure.message, 'Authentication failed');
    });

    test('maps DioException badResponse 422 to ValidationFailure', () {
      final failure = ErrorHandler.mapException(
        DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 422,
            requestOptions: RequestOptions(path: '/x'),
            data: {'message': 'email required'},
          ),
          requestOptions: RequestOptions(path: '/x'),
        ),
      );
      expect(failure, isA<ValidationFailure>());
      expect(failure.message, 'email required');
    });

    test('maps DioException badResponse 500 to ServerFailure', () {
      final failure = ErrorHandler.mapException(
        DioException(
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/x'),
          ),
          requestOptions: RequestOptions(path: '/x'),
        ),
      );
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 500);
    });

    test('maps supabase AuthException to AuthFailure', () {
      final failure = ErrorHandler.mapException(
        const supabase.AuthException('invalid login'),
      );
      expect(failure, isA<AuthFailure>());
      expect(failure.message, 'invalid login');
    });

    test('maps supabase PostgrestException to ServerFailure', () {
      final failure = ErrorHandler.mapException(
        const supabase.PostgrestException(
          message: 'row level security',
          code: '42501',
        ),
      );
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 42501);
    });

    test('maps generic Exception to ServerFailure', () {
      final failure = ErrorHandler.mapException(Exception('whatever'));
      expect(failure, isA<ServerFailure>());
    });
  });

  group('ErrorHandler.guard', () {
    test('returns the value on success', () async {
      final result = await ErrorHandler.guard(() async => 42);
      expect(result, 42);
    });

    test('throws mapped Failure on ApiException', () async {
      expect(
        () => ErrorHandler.guard<int>(
          () async => throw const AuthException(message: 'nope'),
        ),
        throwsA(isA<AuthFailure>()),
      );
    });

    test('throws mapped Failure on generic Exception', () async {
      expect(
        () => ErrorHandler.guard<int>(
          () async => throw Exception('boom'),
        ),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
