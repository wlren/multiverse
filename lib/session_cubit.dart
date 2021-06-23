//Packages
import 'package:flutter_bloc/flutter_bloc.dart';

//Local Files
import '../auth/auth_credentials.dart';
import 'repository/auth_repository.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepository;

  SessionCubit({required this.authRepository}) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void showAuth() => emit(Unauthenticated());

  void showSession(AuthCredentials credentials) {
    //temp
    final userID = credentials.userID;
    emit(Authenticated(userID: userID));
  }

  void signOut() {
    authRepository.signOut();
    emit(Unauthenticated());
  }

  void attemptAutoLogin() async {
    try {
      String userId = authRepository.attemptAutoLogin();
      print(userId);
      emit(Authenticated(userID: userId));
    } on Exception {
      emit(Unauthenticated());
    }
  }
}
