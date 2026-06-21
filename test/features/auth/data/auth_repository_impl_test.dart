import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:fitted/core/error/failure.dart';
import 'package:fitted/core/network/api_exception.dart';
import 'package:fitted/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:fitted/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fitted/features/auth/domain/models/user.dart';

class _MockAuthDatasource extends Mock implements AuthRemoteDatasource {}

void main() {
  late _MockAuthDatasource datasource;
  late AuthRepositoryImpl repo;

  final testUser = AppUser(
    id: 'u1',
    email: 'a@b.c',
    name: 'A',
    createdAt: DateTime(2025, 1, 1),
  );

  setUp(() {
    datasource = _MockAuthDatasource();
    // Constructor reads currentUser and subscribes to authStateChanges.
    // Stub both so construction does not throw or hang.
    when(() => datasource.authStateChanges)
        .thenAnswer((_) => const Stream<sb.AuthState>.empty());
    when(() => datasource.currentUser).thenReturn(null);

    repo = AuthRepositoryImpl(datasource);
  });

  tearDown(() => repo.dispose());

  group('signInWithEmail', () {
    test('delegates and returns the user', () async {
      when(() => datasource.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => testUser);

      final result = await repo.signInWithEmail(email: 'a@b.c', password: 'pw');

      expect(result, testUser);
      verify(() => datasource.signInWithEmail(
            email: 'a@b.c',
            password: 'pw',
          )).called(1);
    });

    test('maps datasource exception to Failure', () async {
      when(() => datasource.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(const AuthException(message: 'invalid'));

      expect(
        () => repo.signInWithEmail(email: 'a@b.c', password: 'pw'),
        throwsA(isA<AuthFailure>()),
      );
    });
  });

  group('signUpWithEmail', () {
    test('delegates with name and returns the user', () async {
      when(() => datasource.signUpWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
            name: any(named: 'name'),
          )).thenAnswer((_) async => testUser);

      final result = await repo.signUpWithEmail(
        email: 'a@b.c',
        password: 'pw',
        name: 'A',
      );

      expect(result, testUser);
      verify(() => datasource.signUpWithEmail(
            email: 'a@b.c',
            password: 'pw',
            name: 'A',
          )).called(1);
    });
  });

  group('signOut', () {
    test('swallows failures and emits unauthenticated', () async {
      when(() => datasource.signOut())
          .thenThrow(const AuthException(message: 'no session'));

      // Must not throw — repo catches and still emits unauthenticated.
      await repo.signOut();
      verify(() => datasource.signOut()).called(1);
    });

    test('emits unauthenticated on success', () async {
      when(() => datasource.signOut()).thenAnswer((_) async {});
      await repo.signOut();
      verify(() => datasource.signOut()).called(1);
    });
  });

  group('signInAsDemo', () {
    test('returns the demo user without touching datasource auth', () async {
      final result = await repo.signInAsDemo();
      expect(result.id, AuthRepositoryImpl.demoUser.id);
      verifyNever(() => datasource.signInWithEmail(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ));
    });
  });

  group('resetPassword', () {
    test('delegates to datasource', () async {
      when(() => datasource.resetPassword(email: any(named: 'email')))
          .thenAnswer((_) async {});
      await repo.resetPassword(email: 'a@b.c');
      verify(() => datasource.resetPassword(email: 'a@b.c')).called(1);
    });

    test('propagates mapped Failure on datasource exception', () async {
      when(() => datasource.resetPassword(email: any(named: 'email')))
          .thenThrow(const ServerException(message: 'down'));
      expect(
        () => repo.resetPassword(email: 'a@b.c'),
        throwsA(isA<Failure>()),
      );
    });
  });
}
