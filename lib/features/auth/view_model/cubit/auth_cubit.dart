import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/model/user_model.dart';
import '../../model/repository/auth_repository.dart';
import 'auth_state.dart';
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repo;

  AuthCubit(this._repo) : super(AuthInitial());

  Future<void> signUp(User user) async {
    emit(AuthLoading());
    try {
      final newUser = await _repo.signUp(user);
      print('✅ CUBIT signUp success: ${newUser.id}'); // ← ADD
      emit(AuthAuthenticated(newUser));
    } catch (e) {
      print('❌ CUBIT signUp error: $e'); // ← ADD
      final msg = e.toString().replaceFirst("Exception: ", "");
      emit(AuthFailure(msg));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _repo.login(email, password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      final msg = e.toString().replaceFirst("Exception: ", "");
      emit(AuthFailure(msg));
    }
  }
}