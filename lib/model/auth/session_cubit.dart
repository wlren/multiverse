//Packages
import 'package:flutter_bloc/flutter_bloc.dart';

//Local Files
import '../../repository/auth_repository.dart';
import 'auth_credentials.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepository;
  late String userId;

  SessionCubit({required this.authRepository}) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void showAuth() => emit(Unauthenticated());

  void showSession(AuthCredentials credentials) async {
    userId = credentials.userId;
    emit(Authenticated(userId: userId));
  }

  void signOut() {
    authRepository.signOut();
    emit(Unauthenticated());
  }

  void attemptAutoLogin() async {
    try {
      userId = authRepository.attemptAutoLogin();
      emit(Authenticated(userId: userId));
    } on Exception {
      emit(Unauthenticated());
    }
  }
}
