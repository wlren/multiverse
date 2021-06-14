class AuthCredentials {
  final String nusNetID;
  final String? email;
  final String? password;
  String? matricID;

  AuthCredentials({
    required this.nusNetID,
    this.email,
    this.password,
    this.matricID,
  });
}
