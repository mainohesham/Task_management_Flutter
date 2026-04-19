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
          'gender': user.gender,           // ✅ ADD
          'level': user.academicLevel,     // ✅ ADD
        },
      );
      print('🔍 SIGNUP RESPONSE: ${response.data}');

      // ✅ Check if signup failed
      if (response.data['status'] == 'fail') {
        throw Exception(response.data['message']);
      }

      // ✅ Get user_id then fetch full profile
      final userId = response.data['user_id'];
      final profileResponse = await _dio.get(
        '${ApiConstants.getProfile}/$userId',
      );
      print('🔍 PROFILE RESPONSE: ${profileResponse.data}');
      return User.fromJson(profileResponse.data['data']); // ← add ['data']

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
      print('🔍 LOGIN RESPONSE: ${response.data}');

      // ✅ Check if login failed
      if (response.data['status'] == 'fail') {
        throw Exception(response.data['message']);
      }

      // ✅ Get user_id then fetch full profile
      final userId = response.data['user_id'];
      final profileResponse = await _dio.get(
        '${ApiConstants.getProfile}/$userId',
      );
      print('🔍 PROFILE RESPONSE: ${profileResponse.data}');
      return User.fromJson(profileResponse.data['data']); // ← add ['data']

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
      return User.fromJson(response.data['data']);  // ← add ['data'];
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
      print('🔍 UPDATE PROFILE RESPONSE: ${response.data}');

      // ✅ backend returns no user data → fetch fresh profile
      if (response.data['status'] == 'success') {
        final profileResponse = await _dio.get(
          '${ApiConstants.getProfile}/${user.id}',
        );
        return User.fromJson(profileResponse.data['data']);
      }
      throw Exception(response.data['message']);

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
      print('🔍 UPDATE PHOTO RESPONSE: ${response.data}'); // ← ADD
      return User.fromJson(response.data['data']); // ← assume same for now
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