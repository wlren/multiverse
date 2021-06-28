//Packages
import 'package:flutter_bloc/flutter_bloc.dart';

//Local Files
import '../../repository/auth_repository.dart';
import 'session_state.dart';
import 'user.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepository;
  AuthUser? user;

  SessionCubit({required this.authRepository}) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void showAuth() => emit(Unauthenticated());

  void showSession(AuthUser user) async {
    emit(Authenticated(user));
  }

  Future<String> login(
      {required String email, required String password}) async {
    return await authRepository.login(email: email, password: password);
  }

  void logout() {
    authRepository.logout();
    emit(Unauthenticated());
  }

  void attemptAutoLogin() async {
    try {
      final user = authRepository.attemptAutoLogin();
      emit(Authenticated(user));
    } on Exception {
      emit(Unauthenticated());
    }
  }
}
