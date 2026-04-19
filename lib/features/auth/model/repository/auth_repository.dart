import '../model/user_model.dart';
import '../service/auth_service.dart';
import '../service/auth_api_service.dart';

class AuthRepository {
  final AuthService _localService;
  final AuthApiService _apiService;

  AuthRepository(this._localService, this._apiService);

  Future<User> signUp(User user) async {
    try {
      // 1️⃣ Register on backend
      final apiUser = await _apiService.signUp(user);
      // 2️⃣ Cache locally — wrap in try/catch so it doesn't stop flow
      try {
        await _localService.signUp(apiUser);
      } catch (_) {
        // ignore if already exists locally
      }
      return apiUser; // ← always return apiUser
    } catch (e) {
      rethrow;
    }
  }

  Future<User> login(String email, String password) async {
    // 1️⃣ Login on backend
    final apiUser = await _apiService.login(email, password);
    // 2️⃣ Cache locally (ignore if already exists)
    try {
      await _localService.signUp(apiUser);
    } catch (_) {}
    return apiUser;
  }

  Future<User> getUserById(int userId) async {
    try {
      final apiUser = await _apiService.getProfile(userId);
      // ✅ ignore local sync errors
      try {
        await _localService.updateUser(apiUser);
      } catch (_) {
        try {
          await _localService.signUp(apiUser);
        } catch (_) {}
      }
      return apiUser;
    } catch (e) {
      print('❌ API failed → local fallback: $e');
      return _localService.getUserById(userId);
    }
  }

  Future<User> updateUser(User user) async {
    // 1️⃣ Update on backend
    final updatedUser = await _apiService.updateProfile(user);
    // 2️⃣ Try sync to local — ignore if fails
    try {
      await _localService.updateUser(updatedUser);
    } catch (e) {
      print('⚠️ Local sync failed (ignored): $e');
    }
    return updatedUser;
  }

  Future<User> updateProfilePhoto(int userId, String imagePath) async {
    // 1️⃣ Send to backend
    final updatedUser = await _apiService.updateProfilePhoto(userId, imagePath);
    // 2️⃣ Try sync to local — ignore if fails
    try {
      await _localService.updateUser(updatedUser);
    } catch (e) {
      print('⚠️ Local sync failed (ignored): $e');
    }
    return updatedUser;
  }

// ❌ Removed getUsers() — not needed with backend
}