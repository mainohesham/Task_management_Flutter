import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/model/model/user_model.dart';
import '../../../auth/model/repository/auth_repository.dart';
import '../state/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _repository;

  ProfileCubit(this._repository) : super(ProfileInitial());

  // ✅ Load user by id
  Future<void> loadUser(int userId) async {
    emit(ProfileLoading());
    try {
      final user = await _repository.getUserById(userId);
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  // ✅ Update profile — use API response not local user
  Future<void> updateProfile(User user) async {
    emit(ProfileLoading());
    try {
      final updatedUser = await _repository.updateUser(user); // ← get updated user back
      emit(ProfileUpdated(updatedUser)); // ← use API response
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }

  // ✅ NEW — Update profile photo
  Future<void> updateProfilePhoto(int userId, String imagePath) async {
    emit(ProfileLoading());
    try {
      final updatedUser = await _repository.updateProfilePhoto(userId, imagePath);
      emit(ProfileUpdated(updatedUser));
    } catch (e) {
      emit(ProfileFailure(e.toString()));
    }
  }
}