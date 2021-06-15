class AuthCredentials {
  final String? nusNetID;
  final String email;
  final String? password;
  String? matricID;

  AuthCredentials({
    this.nusNetID,
    required this.email,
    this.password,
    this.matricID,
  });
}
