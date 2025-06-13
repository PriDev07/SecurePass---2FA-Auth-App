import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class fb {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference otps = FirebaseFirestore.instance.collection(
    'verifications',
  );
  // Sign in function
  Future<void> signInwithemailPass({
    required String email,
    required String pass,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: pass,
    );
  }
  // Sign up function
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String pass,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    );
  }

  Future<void> addOtp({required String email, required String Otp}) async {
    await _firebaseFirestore.collection('verifications').doc(email).set({
      'otp': Otp,
    });
  }

  // Otp checking function
  Future<bool> checkotp({
    required String email,
    required String enteredOtp,
  }) async {
    try {
      DocumentSnapshot doc =
          await _firebaseFirestore.collection('verifications').doc(email).get();

      if (doc.exists) {
        String storedOtp = doc.get('otp');

        if (storedOtp == enteredOtp) {
          // OTP matched
          return true;
        } else {
          // OTP did not match
          return false;
        }
      } else {
        // Document does not exist
        return false;
      }
    } catch (e) {
      print('Error checking OTP: $e');
      return false;
    }
  }
}
