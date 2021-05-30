//For testing purposes
//Authentication related repository which communicates with backend API to fetch
//authentication -related data
class AuthRepository {
  Future<void> login() async {
    //print('attempting login');
    await Future.delayed(const Duration(seconds: 2));
    //print('logged in');
    throw Exception('failed log in');
  }
}
