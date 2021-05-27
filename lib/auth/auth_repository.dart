// For testing purposes
class AuthRepository {
  Future<void> login() async {
    //print('attempting login');
    await Future.delayed(const Duration(seconds: 2));
    //print('logged in');
    throw Exception('failed log in');
  }
}
