import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/supabase_client.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/models/auth_state.dart';
import '../../domain/models/user.dart';

final authDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasourceImpl(ref.watch(supabaseClientProvider));
});

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final ds = ref.watch(authDatasourceProvider);
  return AuthRepositoryImpl(ds);
});

final authStateProvider = StreamProvider<AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateStream;
});

final currentUserProvider = Provider<AppUser?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.valueOrNull?.user;
});

/// Notifier for auth actions (sign in, sign up, sign out)
final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, void>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signInWithEmail(email: email, password: password);
    });
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signUpWithEmail(email: email, password: password, name: name);
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signInWithGoogle();
    });
  }

  Future<void> signInWithApple() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signInWithApple();
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.signOut();
    });
  }

  Future<void> resetPassword({required String email}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      await repo.resetPassword(email: email);
    });
  }
}
