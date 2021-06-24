//Packages
import 'package:flutter_bloc/flutter_bloc.dart';

//Local Files
import 'auth_credentials.dart';
import 'session_cubit.dart';

enum AuthState { login, signUp, confirmSignUp }

//Might be not needed
class AuthCubit extends Cubit<AuthState> {
  final SessionCubit sessionCubit;

  AuthCubit({required this.sessionCubit}) : super(AuthState.login);

  AuthCredentials? credentials;

  void showLogin() => emit(AuthState.login);
  void launchSession(AuthCredentials credentials) =>
      sessionCubit.showSession(credentials);
}
