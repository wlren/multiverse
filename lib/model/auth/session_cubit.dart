//Packages
import 'package:flutter_bloc/flutter_bloc.dart';

//Local Files
import '../../repository/auth_repository.dart';
import 'auth_credentials.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepository;
  late String userUID;

  SessionCubit({required this.authRepository}) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void showAuth() => emit(Unauthenticated());

  void showSession(AuthCredentials credentials) {
    userUID = credentials.userID;
    emit(Authenticated(userID: userUID));
  }

  void signOut() {
    authRepository.signOut();
    print('signed out');
    emit(Unauthenticated());
  }

  void attemptAutoLogin() async {
    try {
      userUID = authRepository.attemptAutoLogin();
      print(userUID);
      emit(Authenticated(userID: userUID));
    } on Exception {
      emit(Unauthenticated());
    }
  }
}
