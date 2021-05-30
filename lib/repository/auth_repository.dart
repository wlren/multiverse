//For testing purposes
//Authentication related repository which communicates with backend API to fetch
//authentication -related data
class AuthRepository {
  Future<String> attemptAutoLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    throw Exception('not signed in');
  }

  Future<String> login(
      {required String username, required String password}) async {
    //print('attempting login');
    final userID =
        await Future.delayed(const Duration(seconds: 2), () => "USER ID");
    return userID;
    //throw Exception('failed log in');
  }

  Future<void> signOut() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );
  }
}
