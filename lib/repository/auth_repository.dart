import 'package:firebase_auth/firebase_auth.dart';

import '../model/auth/user.dart';

//For testing purposes
//Authentication related repository which communicates with backend API to fetch
//authentication -related data

abstract class LoginException implements Exception {
  LoginException(this.message);

  final String message;
}

class InvalidEmailException implements LoginException {
  InvalidEmailException(this._message);

  final String _message;

  @override
  String get message => _message;
}

class InvalidPasswordException implements LoginException {
  InvalidPasswordException(this._message);

  final String _message;

  @override
  String get message => _message;
}

class FailedAutoLoginException implements LoginException {
  FailedAutoLoginException(this._message);

  final String _message;

  @override
  String get message => _message;
}

class AuthRepository {
  AuthRepository();

  final auth = FirebaseAuth.instance;

  /// Attempts automatic log in and retrieval of user id
  ///
  /// Throws a [LoginException] if auto-sign in fails
  AuthUser attemptAutoLogin() {
    if (auth.currentUser != null) {
      return AuthUser(auth.currentUser!.uid);
    } else {
      throw FailedAutoLoginException('Automatic sign in failed');
    }
  }

  /// Returns the user's uid as provided by Firebase.
  ///
  /// Throws a [LoginException] if sign in fails.
  Future<String> login(
      {required String email, required String password}) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        // Should not occur due to form validation
        throw InvalidEmailException('Invalid email address');
      } else if (e.code == 'user-disabled') {
        throw InvalidEmailException('User account disabled');
      } else if (e.code == 'user-not-found') {
        throw InvalidEmailException('No user found');
      } else if (e.code == 'wrong-password') {
        throw InvalidPasswordException('Password incorrect');
      } else {
        rethrow;
      }
    }
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}
