import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/error/failures.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/entity/user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    fb.FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );
});

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._firebaseAuth, this._firestore);

  final fb.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  Future<User?> getCurrentUser() async {
    final fbUser = _firebaseAuth.currentUser;
    if (fbUser == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(fbUser.uid).get();
      if (doc.exists && doc.data() != null) {
        return User.fromJson(doc.data()!);
      }

      return User(
        id: fbUser.uid,
        name: fbUser.displayName ?? 'No Name',
        email: fbUser.email ?? '',
        role: 'user',
      );
    } catch (e) {
      return User(
        id: fbUser.uid,
        name: fbUser.displayName ?? 'No Name',
        email: fbUser.email ?? '',
        role: 'user',
      );
    }
  }

  @override
  Future<User> login(String email, String password, String role) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final fbUser = credential.user;
      if (fbUser == null) {
        throw const AuthFailure('User authentication failed.');
      }

      final doc = await _firestore.collection('users').doc(fbUser.uid).get();
      if (doc.exists && doc.data() != null) {
        final user = User.fromJson(doc.data()!);

        if (user.role != role) {
          await _firebaseAuth.signOut();
          throw BussinessFailure(
            'Access denied: Your account does not have ${user.role} privileges.',
          );
        }

        return user;
      }

      final defaultUser = User(
        id: fbUser.uid,
        name: fbUser.displayName ?? email.split('@').first,
        email: email,
        role: 'user',
      );
      await _firestore
          .collection('users')
          .doc(fbUser.uid)
          .set(defaultUser.toJson());
      return defaultUser;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(_mapAuthError(e.code, e.message));
    } on BussinessFailure catch(e) {
      throw AuthFailure(e.message);
    }
     catch (e) {
      throw AuthFailure(
        'An unexpected error occurred during login. Please check your network and try again.',
      );
    }
  }

  @override
  Future<User> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final fbUser = credential.user;
      if (fbUser == null) {
        throw const AuthFailure('User registration failed.');
      }

      await fbUser.updateDisplayName(name);

      final newUser = User(
        id: fbUser.uid,
        name: name,
        email: email,
        role: role.toLowerCase(),
      );

      await _firestore
          .collection('users')
          .doc(fbUser.uid)
          .set(newUser.toJson());

      return newUser;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthFailure(_mapAuthError(e.code, e.message));
    } catch (e) {
      throw const AuthFailure(
        'An unexpected error occurred during registration. Please check your network and try again.',
      );
    }
  }

  String _mapAuthError(String code, String? defaultMessage) {
    return switch (code) {
      'invalid-credential' => 'your email or password incorrect.',
      'invalid-email' => 'Please enter a valid email address.',
      'user-disabled' => 'This account has been disabled.',
      'user-not-found' => 'No account found with this email.',
      'wrong-password' => 'Incorrect password. Please try again.',
      'email-already-in-use' =>
        'This email is already in use by another account.',
      'weak-password' =>
        'The password provided is too weak. Must be at least 6 characters.',
      'operation-not-allowed' => 'Email/password accounts are not enabled.',
      'network-request-failed' =>
        'Connection failed. Please check your internet connection and try again.',
      _ => defaultMessage ?? 'Authentication failed.',
    };
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
