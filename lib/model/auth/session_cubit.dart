//Packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_database/firebase_database.dart';

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

  void showSession(AuthCredentials credentials) async {
    userUID = credentials.userID;
    emit(Authenticated(userID: userUID));
  }

  void signOut() {
    authRepository.signOut();
    emit(Unauthenticated());
  }

  void attemptAutoLogin() async {
    try {
      userUID = authRepository.attemptAutoLogin();
      emit(Authenticated(userID: userUID));
    } on Exception {
      emit(Unauthenticated());
    }
  }

  // Future<String> _setID(String userUID) async {
  //   print(userUID);
  //   final nameReference = await db.child('students/$userUID').get();
  //   print(nameReference!.value['name']);
  //   return 'got here';
  // }
}
