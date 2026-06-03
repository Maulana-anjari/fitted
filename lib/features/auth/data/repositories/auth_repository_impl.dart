import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failure.dart';
import '../../domain/models/user.dart';
import '../../domain/models/auth_state.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;
  final StreamController<AuthState> _controller;

  AuthRepositoryImpl(this._datasource)
      : _controller = StreamController<AuthState>.broadcast() {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _datasource.authStateChanges.listen((sb.AuthState event) {
      if (event.session != null) {
        _fetchAndEmitUser(event.session!.user.id);
      } else {
        _controller.add(AuthState.unauthenticated());
      }
    });

    // Check initial session
    final initialUser = _datasource.currentUser;
    if (initialUser != null) {
      _controller.add(AuthState.authenticated(initialUser));
    } else {
      _controller.add(AuthState.initial());
    }
  }

  Future<void> _fetchAndEmitUser(String userId) async {
    try {
      final data = await sb.Supabase.instance.client
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (data != null) {
        _controller.add(AuthState.authenticated(AppUser.fromJson(Map<String, dynamic>.from(data as Map))));
        return;
      }
    } catch (_) {}

    // Fallback to datasource's current user
    final user = _datasource.currentUser;
    if (user != null) {
      _controller.add(AuthState.authenticated(user));
    }
  }

  @override
  Stream<AuthState> get authStateStream => _controller.stream;

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final user = await ErrorHandler.guard(() {
      return _datasource.signInWithEmail(email: email, password: password);
    });
    _controller.add(AuthState.authenticated(user));
    return user;
  }

  @override
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    final user = await ErrorHandler.guard(() {
      return _datasource.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      );
    });
    _controller.add(AuthState.authenticated(user));
    return user;
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    final user = await ErrorHandler.guard(() => _datasource.signInWithGoogle());
    _controller.add(AuthState.authenticated(user));
    return user;
  }

  @override
  Future<AppUser> signInWithApple() async {
    final user = await ErrorHandler.guard(() => _datasource.signInWithApple());
    _controller.add(AuthState.authenticated(user));
    return user;
  }

  @override
  Future<void> signOut() async {
    await ErrorHandler.guard(() => _datasource.signOut());
    _controller.add(AuthState.unauthenticated());
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await ErrorHandler.guard(() => _datasource.resetPassword(email: email));
  }

  @override
  Future<void> updateProfile({String? name, String? avatarUrl}) async {
    await ErrorHandler.guard(
      () => _datasource.updateProfile(name: name, avatarUrl: avatarUrl),
    );
  }

  void dispose() {
    _controller.close();
  }
}
