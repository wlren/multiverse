//Packages
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

//For testing purposes
//Authentication related repository which communicates with backend API to fetch
//authentication -related data

class AuthRepository {
  Future<String> _getUserIdFromAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final userId = attributes
          .firstWhere((element) => element.userAttributeKey == 'sub')
          .value as String;
      return userId;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> attemptAutoLogin() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();

      return session.isSignedIn ? (await _getUserIdFromAttributes()) : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> login(
      {required String username, required String password}) async {
    try {
      final result = await Amplify.Auth.signIn(
          username: username.trim(), password: password.trim());

      return result.isSignedIn ? (await _getUserIdFromAttributes()) : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await Amplify.Auth.signOut();
  }

  Future<void> register() async {
    try {
      // Map<String, String> userAttributes = {
      //   'email': 'email@domain.com',
      //   'phone_number': '+15559101234',
      //   // additional attributes as needed
      // };
      SignUpResult res = await Amplify.Auth.signUp(
          username: 'e0000000',
          password: 'password',
          options: CognitoSignUpOptions(
              userAttributes: {'email': 'weilin513626@gmail.com'}));
      //options: CognitoSignUpOptions(userAttributes: userAttributes));
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> confirmRegister() async {
    try {
      SignUpResult res = await Amplify.Auth.confirmSignUp(
          username: 'myusername', confirmationCode: '123456');
    } on AuthException catch (e) {
      print(e.message);
    }
  }
}
