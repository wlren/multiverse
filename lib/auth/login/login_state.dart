//Local Files
import '../form_submission_status.dart';

//State keeping for login status
class LoginState {
  /* VARIABLES start */
  final String email;

  //Check if username is exxxxxxx@u.nus.edu
  bool get isEmailValid {
    return RegExp(r'^e\d{7}@u.nus.edu$').hasMatch(email);
  }

  final String password;
  bool get isPasswordValid => password.isNotEmpty;
  final FormSubmissionStatus formStatus;
  /* VARIABLES end */

  // Constructor with default values
  LoginState({
    this.email = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  //Updates either the password or username and recreates the state
  LoginState copyWith({
    String? email,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
