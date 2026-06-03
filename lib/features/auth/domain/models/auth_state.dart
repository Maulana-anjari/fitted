import 'user.dart';

enum AuthStatus { initial, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final AppUser? user;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isInitial => status == AuthStatus.initial;

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: clearError ? null : error ?? this.error,
    );
  }

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  factory AuthState.authenticated(AppUser user) => AuthState(
        status: AuthStatus.authenticated,
        user: user,
      );

  factory AuthState.unauthenticated({String? error}) => AuthState(
        status: AuthStatus.unauthenticated,
        error: error,
      );
}
