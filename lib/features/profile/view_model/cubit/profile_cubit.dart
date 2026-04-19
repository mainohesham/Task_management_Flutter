import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/model/model/user_model.dart';
import '../../../auth/model/repository/auth_repository.dart';
import '../state/profile_state.dart';


class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _repository;

  ProfileCubit(this._repository) : super(ProfileInitial());

  // Load user by id
  Future<void> loadUser(int userId) async {
    emit(ProfileLoading());
    try {
      final user = await _repository.getUserById(userId);
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  // Update user profile
  Future<void> updateProfile(User user) async {
    emit(ProfileLoading());
    try {
      await _repository.updateUser(user);
      emit(ProfileUpdated(user));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}