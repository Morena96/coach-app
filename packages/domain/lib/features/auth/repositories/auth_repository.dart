abstract class AuthRepository {
  Future<bool> login(String username, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<String?> getAccessToken();
  Future<bool> refreshToken();
}
