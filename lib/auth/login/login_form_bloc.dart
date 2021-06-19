//Packages
import 'package:flutter_bloc/flutter_bloc.dart';

//Local Files
import '../../repository/auth_repository.dart';
import '../auth_credentials.dart';
import '/auth/auth_cubit.dart';
import 'login_form_event.dart';
import 'login_form_state.dart';

//BloC Architecture for login
class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  final AuthRepository authRepo;
  final AuthCubit authCubit;

  LoginFormBloc({required this.authRepo, required this.authCubit})
      : super(const InitialFormState());

  @override
  Stream<LoginFormState> mapEventToState(LoginFormEvent event) async* {
     if (event is LoginFormSubmitted) {
       yield FormSubmitting();

      try {
        final userID = await authRepo.login(
          email: event.email,
          password: event.password,
        );
        yield SubmissionSuccess();

        authCubit
            .launchSession(AuthCredentials(email: event.email, userID: userID));
      } on LoginException catch (e) {
        yield SubmissionFailed(e);
        yield const InitialFormState();
      }
    }
  }
}
