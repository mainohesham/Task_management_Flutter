import '../model/user_model.dart';
import '../service/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<List<User>> getUsers() {
    return _authService.getUsers();
  }

  Future<User> signUp(User user) async {
    return await _authService.signUp(user);
  }

  Future<User> login(String email, String password) async {
    return await _authService.login(email, password);
  }

  // for profile screen :
  Future<User> getUserById(int userId) =>
      _authService.getUserById(userId);

  Future<void> updateUser(User user) =>
      _authService.updateUser(user);
}