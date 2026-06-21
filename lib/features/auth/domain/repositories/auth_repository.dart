import '../models/user.dart';
import '../models/auth_state.dart';

abstract class AuthRepository {
  Stream<AuthState> get authStateStream;

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<AppUser> signInWithGoogle();

  Future<AppUser> signInWithApple();

  Future<void> signOut();

  Future<AppUser> signInAsDemo();

  Future<void> resetPassword({required String email});

  Future<void> updateProfile({
    String? name,
    String? avatarUrl,
  });
}
