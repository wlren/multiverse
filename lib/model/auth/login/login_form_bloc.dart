//Packages
import 'package:flutter_bloc/flutter_bloc.dart';

//Local Files
import '../../../repository/auth_repository.dart';
import '../session_cubit.dart';
import '../user.dart';
import 'login_form_event.dart';
import 'login_form_state.dart';

//BloC Architecture for login
class LoginFormBloc extends Bloc<LoginFormEvent, LoginFormState> {
  final SessionCubit sessionCubit;

  LoginFormBloc({required this.sessionCubit}) : super(const InitialFormState());

  @override
  Stream<LoginFormState> mapEventToState(LoginFormEvent event) async* {
    if (event is LoginFormSubmitted) {
      yield FormSubmitting();
      try {
        final userId = await sessionCubit.login(
          email: event.email,
          password: event.password,
        );
        final user = AuthUser(userId);
        yield SubmissionSuccess();

        sessionCubit.showSession(user);
      } on LoginException catch (e) {
        yield SubmissionFailed(e);
        yield const InitialFormState();
      }
    }
  }
}
