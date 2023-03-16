import 'package:bloc/bloc.dart';
import 'package:flutter_course/services/auth/auth_provider.dart';
import 'package:flutter_course/services/auth/bloc/auth_event.dart';
import 'package:flutter_course/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthProvider _provider;
  AuthBloc(AuthProvider provider)
      : _provider = provider,
        super(const AuthStateLoading()) {
    on<AuthEventInitialize>(_onInitialize);
    on<AuthEventLogIn>(_onLogIn);
    on<AuthEventLogOut>(_onLogOut);
  }

  Future<void> _onInitialize(
      AuthEventInitialize event, Emitter<AuthState> emit) async {
    await _provider.initialiize();
    final user = _provider.currentUser;
    if (user == null) {
      emit(const AuthStateLoggedOut());
    } else if (!user.isEmailVerified) {
      emit(const AuthStateNeedsVerification());
    } else {
      emit(AuthStateLoggedIn(user));
    }
  }

  Future<void> _onLogIn(AuthEventLogIn event, Emitter<AuthState> emit) async {
    final email = event.email;
    final password = event.password;
    try {
      emit(const AuthStateLoading());
      final user = await _provider.login(email: email, password: password);
      emit(AuthStateLoggedIn(user));
    } on Exception catch (e) {
      emit(AuthStateLoginFailure(e));
    }
  }

  Future<void> _onLogOut(AuthEventLogOut event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthStateLoading());
      await _provider.logOut();
      emit(const AuthStateLoggedOut());
    } on Exception catch (e) {
      emit(AuthStateLoggedOutFailure(e));
    }
  }
}
