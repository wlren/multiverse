class AuthCredentials {
  final String userId;
  final String email;
  final String? password;
  String? matricId;

  AuthCredentials({
    required this.userId,
    required this.email,
    this.password,
    this.matricId,
  });
}
