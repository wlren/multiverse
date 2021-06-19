//Local Files
import '../../repository/auth_repository.dart';

abstract class LoginFormState {
  const LoginFormState();
}

class InitialFormState extends LoginFormState {
  const InitialFormState();
}

class FormSubmitting extends LoginFormState {}

class SubmissionSuccess extends LoginFormState {}

class SubmissionFailed extends LoginFormState {
  final LoginException loginException;

  SubmissionFailed(this.loginException);
}
