import 'package:flutter_course/services/auth/auth_provider.dart';
import 'package:flutter_course/services/auth/auth_user.dart';
import 'package:flutter_course/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(
        email: email,
        password: password,
      );

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialiize() => provider.initialiize();

  @override
  Future<void> reload() => provider.reload();

  @override
  Future<void> sendPasswordReset({required String email}) =>
      provider.sendEmailVerification();

  @override
  Future<AuthUser> signInWithGoogle() => provider.signInWithGoogle();
}
