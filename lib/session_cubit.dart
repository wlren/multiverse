//Packages
import 'package:flutter_bloc/flutter_bloc.dart';

//Local Files
import '../auth/auth_credentials.dart';
import '../models/nus_student.dart';
import '../repository/auth_repository.dart';
import '../repository/data_repository.dart';
import '../session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepository;
  final DataRepository dataRepo;

  SessionCubit({required this.authRepository, required this.dataRepo})
      : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void showAuth() => emit(Unauthenticated());

  void showSession(AuthCredentials credentials) async {
    try {
      NUSStudent? user = await dataRepo.getUserById(credentials.nusNetID);
      if (user == null) throw Exception("No such user");
      emit(Authenticated(user: user));
    } catch (e) {
      print(e);
      emit(Unauthenticated());
    }
  }

  void signOut() {
    authRepository.signOut();
    emit(Unauthenticated());
  }

  void attemptAutoLogin() async {
    try {
      final userID = await authRepository.attemptAutoLogin();
      if (userID == null) throw Exception('User not logged in');
      final user = await dataRepo.getUserById(userID);
      if (user == null) throw ('No such user');
      emit(Authenticated(user: user));
    } on Exception {
      emit(Unauthenticated());
    }
  }
}
