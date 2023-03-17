import 'package:bloc/bloc.dart';
import 'package:flutter_course/services/auth/auth_provider.dart';
import 'package:flutter_course/services/auth/bloc/auth_event.dart';
import 'package:flutter_course/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthProvider _provider;
  AuthBloc(AuthProvider provider)
      : _provider = provider,
        super(const AuthStateUninitialize(isLoading: true)) {
    on<AuthEventInitialize>(_onInitialize);
    on<AuthEventLogIn>(_onLogIn);
    on<AuthEventLogOut>(_onLogOut);
    on<AuthEventSendEmailVerification>(_onSendEmailVerification);
    on<AuthEventRegister>(_onRegister);
    on<AuthEventShouldRegister>(_onShouldRegister);
  }

  Future<void> _onInitialize(
      AuthEventInitialize event, Emitter<AuthState> emit) async {
    await _provider.initialiize();
    final user = _provider.currentUser;
    if (user == null) {
      emit(const AuthStateLoggedOut(exception: null, isLoading: false));
    } else if (!user.isEmailVerified) {
      emit(const AuthStateNeedsVerification(isLoading: false));
    } else {
      emit(AuthStateLoggedIn(user: user, isLoading: false));
    }
  }

  Future<void> _onLogIn(AuthEventLogIn event, Emitter<AuthState> emit) async {
    emit(const AuthStateLoggedOut(
      exception: null,
      isLoading: true,
      loadingText: 'Please wait while I log you in',
    ));
    final email = event.email;
    final password = event.password;
    try {
      final user = await _provider.login(email: email, password: password);
      if (!user.isEmailVerified) {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));
      }
    } on Exception catch (e) {
      emit(AuthStateLoggedOut(
        exception: e,
        isLoading: false,
      ));
    }
  }

  Future<void> _onLogOut(AuthEventLogOut event, Emitter<AuthState> emit) async {
    try {
      await _provider.logOut();
      emit(const AuthStateLoggedOut(
        exception: null,
        isLoading: false,
      ));
    } on Exception catch (e) {
      emit(AuthStateLoggedOut(exception: e, isLoading: false));
    }
  }

  Future<void> _onRegister(
      AuthEventRegister event, Emitter<AuthState> emit) async {
    final email = event.email;
    final password = event.password;

    try {
      await _provider.createUser(
        email: email,
        password: password,
      );
      await _provider.sendEmailVerification();
      emit(const AuthStateNeedsVerification(isLoading: false));
    } on Exception catch (e) {
      emit(AuthStateRegistering(
        exception: e,
        isLoading: false,
      ));
    }
  }

  Future<void> _onSendEmailVerification(
    AuthEventSendEmailVerification event,
    Emitter<AuthState> emit,
  ) async {
    await _provider.sendEmailVerification();
    emit(state);
  }

  Future<void> _onShouldRegister(
      AuthEventShouldRegister event, Emitter<AuthState> emit) async {
    emit(const AuthStateRegistering(isLoading: false, exception: null));
  }
}
