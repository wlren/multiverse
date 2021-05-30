//Packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiverse/repository/auth_repository.dart';

//Local Files
import '../auth/auth_credentials.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepository;

  SessionCubit({required this.authRepository}) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void showAuth() => emit(Unauthenticated());
  void showSession(AuthCredentials credentials) {
    //temp
    final user = credentials.userID;
    emit(Authenticated(user: user));
  }

  void signOut() {
    authRepository.signOut();
    emit(Unauthenticated());
  }

  void attemptAutoLogin() async {
    try {
      final userID = await authRepository.attemptAutoLogin();
      //temp
      final user = userID;
      emit(Authenticated(user: user));
    } on Exception {
      emit(Unauthenticated());
    }
  }
}
