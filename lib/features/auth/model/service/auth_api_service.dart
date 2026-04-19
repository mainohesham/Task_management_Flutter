import 'package:dio/dio.dart';
import '../../../../core/api_constants/api_constants.dart';
import '../../../../core/dio_client/dio_client.dart';
import '../model/user_model.dart';

class AuthApiService {
  final Dio _dio = DioClient.instance;

  // ✅ Sign Up
  Future<User> signUp(User user) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: {
          'full_name': user.fullName,
          'email': user.email,
          'password': user.password,
          'student_id': user.studentID,
        },
      );
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Login
  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Get Profile
  Future<User> getProfile(int userId) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.getProfile}/$userId',
      );
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Update Profile
  Future<User> updateProfile(User user) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.updateProfile}/${user.id}',
        data: user.toJson(),
      );
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Update Profile Photo
  Future<User> updateProfilePhoto(int userId, String imagePath) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.updatePhoto}/$userId/image',
        data: {'profile_image': imagePath},
      );
      return User.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ✅ Error Handler
  Exception _handleError(DioException e) {
    if (e.response != null) {
      final msg = e.response?.data['message'] ??
          e.response?.data['error'] ??
          'Something went wrong';
      return Exception(msg);
    }
    return Exception('No internet connection');
  }
}