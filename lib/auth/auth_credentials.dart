class AuthCredentials {
  final String userID;
  final String email;
  final String? password;
  String? matricID;

  AuthCredentials({
    required this.userID,
    required this.email,
    this.password,
    this.matricID,
  });
}
