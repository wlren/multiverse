//Local Files
import '../form_submission_status.dart';

//State keeping for login status
class LoginState {
  /* VARIABLES start */
  final String email;

  //Check if username is exxxxxxx@u.nus.edu
  bool get isValidEmail {
    return email.length == 18 &&
        int.tryParse(email.substring(1, 8)) != null &&
        email.substring(0, 1) == 'e' &&
        email.substring(8) == '@u.nus.edu';
  }

  final String password;
  bool get isValidPassword => password.isNotEmpty;
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
