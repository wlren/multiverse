//Login related event classes
abstract class LoginFormEvent {}

class LoginFormSubmitted extends LoginFormEvent {
  LoginFormSubmitted({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
