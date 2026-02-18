import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  Future<void> upsertProfile({
    required String userId,
    required String fullName,
    required String email,
  }) async {
    try {
      await _client.from('profiles').upsert({
        'id': userId,
        'full_name': fullName,
        'email': email,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {
      // Keep auth flow alive if the table is not created yet.
    }
  }

  Future<void> signOut() => _client.auth.signOut();
}
