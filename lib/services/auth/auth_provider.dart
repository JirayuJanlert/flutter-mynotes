import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_course/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currrentUser;

  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<void> logOut();
  Future<void> sendEmailVerification();
}//ec
