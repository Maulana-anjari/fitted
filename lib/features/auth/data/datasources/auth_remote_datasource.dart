import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../domain/models/user.dart';

abstract class AuthRemoteDatasource {
  Stream<sb.AuthState> get authStateChanges;

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

  Future<void> resetPassword({required String email});

  Future<void> updateProfile({String? name, String? avatarUrl});

  AppUser? get currentUser;
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final sb.SupabaseClient _client;

  AuthRemoteDatasourceImpl(this._client);

  @override
  Stream<sb.AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  @override
  AppUser? get currentUser {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return AppUser(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'] as String?,
      createdAt: DateTime.parse(user.createdAt),
    );
  }

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) throw Exception('Sign in failed');

    return _fetchProfile(user.id);
  }

  @override
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );

    final user = response.user;
    if (user == null) throw Exception('Sign up failed');

    return _fetchProfile(user.id);
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(sb.OAuthProvider.google);

    final currentUser = _client.auth.currentUser;
    if (currentUser != null) {
      return _fetchProfile(currentUser.id);
    }
    throw Exception('Google sign in failed');
  }

  @override
  Future<AppUser> signInWithApple() async {
    await _client.auth.signInWithOAuth(sb.OAuthProvider.apple);

    final currentUser = _client.auth.currentUser;
    if (currentUser != null) {
      return _fetchProfile(currentUser.id);
    }
    throw Exception('Apple sign in failed');
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  @override
  Future<void> updateProfile({String? name, String? avatarUrl}) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    updates['updated_at'] = DateTime.now().toIso8601String();

    await _client.from('user_profiles').update(updates).eq('id', userId);
  }

  Future<AppUser> _fetchProfile(String userId) async {
    final data = await _client
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (data == null) {
      final authUser = _client.auth.currentUser;
      return AppUser(
        id: userId,
        email: authUser?.email ?? '',
        name: authUser?.userMetadata?['name'] as String?,
        avatarUrl: authUser?.userMetadata?['avatar_url'] as String?,
        createdAt: authUser?.createdAt != null
            ? DateTime.parse(authUser!.createdAt)
            : DateTime.now(),
      );
    }

    return AppUser(
      id: data['id'] as String,
      email: data['email'] as String,
      name: data['name'] as String?,
      avatarUrl: data['avatar_url'] as String?,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
}
