import '../entity/user.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<User> login(String email, String password, String role);
  Future<User> register(
    String name,
    String email,
    String password,
    String role,
  );
  Future<void> logout();
  }
