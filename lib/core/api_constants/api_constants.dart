class ApiConstants {

  static const String baseUrl = 'http://127.0.0.1:5000';

  // Auth
  static const String register = '/signup';
  static const String login    = '/login';

  // Profile
  static const String getProfile    = '/profile';   // GET /profile/:id
  static const String updateProfile = '/profile';   // PUT /profile/:id
  static const String updatePhoto   = '/profile';   // PUT /profile/:id/image

  // Tasks
  static const String tasks        = '/tasks';      // GET+POST /tasks
  static const String completeTask = '/tasks';      // PUT /tasks/:id/complete
}