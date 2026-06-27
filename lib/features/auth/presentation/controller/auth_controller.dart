import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entity/user.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, User?>(
  AuthController.new,
);

class AuthController extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() async {
    return ref.watch(authRepositoryProvider).getCurrentUser();
  }

  Future<void> login(String email, String password, String role) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return ref.read(authRepositoryProvider).login(email, password, role);
    });
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      return ref
          .read(authRepositoryProvider)
          .register(name, email, password, role);
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).logout();
      return null;
    });
  }
}
