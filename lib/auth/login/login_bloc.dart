//Packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiverse/auth/auth_credentials.dart';

//Local Files
import '../../repository/auth_repository.dart';
import '../form_submission_status.dart';
import '/auth/auth_cubit.dart';
import 'login_event.dart';
import 'login_state.dart';

//BloC Architecture for login
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository? authRepo;
  final AuthCubit authCubit;

  LoginBloc({this.authRepo, required this.authCubit}) : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    // Username updated
    if (event is LoginUsernameChanged) {
      yield state.copyWith(username: event.username);
      // Password updated
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(password: event.password);
      // Form submitted
    } else if (event is LoginSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        final userID = await authRepo?.login(
          username: state.username,
          password: state.password,
        );
        yield state.copyWith(formStatus: SubmissionSuccess());

        authCubit.launchSession(
            AuthCredentials(nusNetID: state.username, userID: userID));
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
        yield state.copyWith(formStatus: const InitialFormStatus());
      }
    }
  }
}
