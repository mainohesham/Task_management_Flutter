import '../model/user_model.dart';
import '../service/auth_service.dart';
import '../service/auth_api_service.dart';

class AuthRepository {
  final AuthService _localService;
  final AuthApiService _apiService;

  AuthRepository(this._localService, this._apiService);

  Future<User> signUp(User user) async {
    // 1️⃣ Register on backend
    final apiUser = await _apiService.signUp(user);
    // 2️⃣ Cache locally
    await _localService.signUp(apiUser);
    return apiUser;
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
      // 1️⃣ Try API first → fresh data
      final apiUser = await _apiService.getProfile(userId);
      // 2️⃣ Sync to local
      await _localService.updateUser(apiUser);
      return apiUser;
    } catch (_) {
      // 3️⃣ Offline fallback
      return _localService.getUserById(userId);
    }
  }

  Future<User> updateUser(User user) async {
    // 1️⃣ Update on backend
    final updatedUser = await _apiService.updateProfile(user);
    // 2️⃣ Sync to local
    await _localService.updateUser(updatedUser);
    return updatedUser;
  }

  Future<User> updateProfilePhoto(int userId, String imagePath) async {
    // 1️⃣ Send to backend
    final updatedUser = await _apiService.updateProfilePhoto(userId, imagePath);
    // 2️⃣ Sync to local
    await _localService.updateUser(updatedUser);
    return updatedUser;
  }

// ❌ Removed getUsers() — not needed with backend
}