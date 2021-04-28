import 'package:firebase_auth/firebase_auth.dart';

class UserAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static final String passwordError = "password error";
  static final String emailError = "email error";

  //Using Stream to listen to Authentication State
  Stream<User> get authState => _firebaseAuth.idTokenChanges();

  //SIGN UP METHOD
  Future signUp(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  //SIGN IN METHOD
  Future<User> signIn(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        throw Exception(passwordError);
      } else if (e.code == "user-not-found") {
        throw Exception(emailError);
      }

      print(e.message);
      return null;
    }
  }

  //SIGN OUT METHOD
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
