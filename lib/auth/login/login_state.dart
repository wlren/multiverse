//Local Files
import '../form_submission_status.dart';

//State keeping for login status
class LoginState {
  /* VARIABLES start */
  final String username;

  //Check if username is exxxxxxxx
  bool get isValidUsername {
    return username.length == 8 &&
        int.tryParse(username.substring(1)) != null &&
        username.substring(0, 1) == 'e';
  }

  final String password;
  bool get isValidPassword => password.isNotEmpty;
  final FormSubmissionStatus formStatus;
  /* VARIABLES end */

  // Constructor with default values
  LoginState({
    this.username = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  //Updates either the password or username and recreates the state
  LoginState copyWith({
    String? username,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
