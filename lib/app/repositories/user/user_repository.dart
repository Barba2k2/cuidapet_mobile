abstract class UserRepository {
  Future<void> register(String email, String password);
  Future<String> login(String email, String password);
}
