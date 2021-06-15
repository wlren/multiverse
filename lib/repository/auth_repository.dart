import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

//For testing purposes
//Authentication related repository which communicates with backend API to fetch
//authentication -related data
class AuthRepository {
  AuthRepository();

  final auth = FirebaseAuth.instance;

  Future<String> attemptAutoLogin() async {
    await Future.delayed(const Duration(seconds: 0));
    throw Exception('not signed in');
  }

  Future<String?> login(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
