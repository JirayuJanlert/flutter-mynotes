import 'package:flutter_course/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
//to initialize firebase application in  the main file
  Future<void> initialiize();
  Future<AuthUser> login({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<void> reload();
  Future<void> logOut();
  Future<void> sendEmailVerification();
}//ec
