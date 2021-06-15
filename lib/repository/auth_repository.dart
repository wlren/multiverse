//For testing purposes
//Authentication related repository which communicates with backend API to fetch
//authentication -related data
class AuthRepository {
  Future<String> attemptAutoLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    throw Exception('not signed in');
  }

  Future<String> login(
      {required String email, required String password}) async {
    try {
      final userID =
          await Future.delayed(const Duration(seconds: 2), () => 'Token');
      return userID;
    } on Exception catch (e) {
      throw Exception('failed log in');
    }
  }

  Future<void> signOut() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );
  }
}
