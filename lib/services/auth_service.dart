import 'package:firebase_auth/firebase_auth.dart';

class fb {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> signInwithemailPass({
    required String email,
    required String pass,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: pass,
    );
  }
}
