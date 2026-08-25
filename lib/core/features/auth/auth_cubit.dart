import 'package:bloc/bloc.dart';
import 'package:boru_crm/core/features/auth/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

class AuthCubit extends Cubit<AuthState> {
  final SupabaseClient _client = Supabase.instance.client;

  AuthCubit() : super(AuthInitial()) {
    // Uygulama açılışında mevcut oturumu kontrol et
    final session = _client.auth.currentSession;
    emit(session != null ? AuthAuthenticated() : AuthUnauthenticated());
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      await _client.auth.signUp(email: email, password: password);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    emit(AuthUnauthenticated());
  }
}
