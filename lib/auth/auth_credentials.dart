class AuthCredentials {
  final String nusNetID;
  final String? email;
  final String? password;
  String? userID;

  AuthCredentials({
    required this.nusNetID,
    this.email,
    this.password,
    this.userID,
  });
}
