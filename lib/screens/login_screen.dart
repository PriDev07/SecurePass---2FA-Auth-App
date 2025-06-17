import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:securepass/screens/otp_screen.dart';
import 'package:securepass/screens/signup_screen.dart';
import 'package:securepass/services/auth_service.dart';
import 'package:securepass/services/mail_service.dart';
import 'package:securepass/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String ErrorMsg = "";
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  final Random _random = Random();
  int _randomNumber = 0;
  // OTP generation function
  void generateRandomNumber() {
    _randomNumber = 1000 + _random.nextInt(9000);
  }
  // Sign in using email method
  Future<void> SignInWithEmailPass() async {
    try {
      generateRandomNumber();
      MailService().sendOtpEmail(
        _emailController.text,
        _randomNumber.toString(),
      );
      await fb().addOtp(
        email: _emailController.text,
        Otp: _randomNumber.toString(),
      );
      await fb().signInwithemailPass(
        email: _emailController.text,
        pass: _passController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (builder) => OtpScreen(
                email: _emailController.text,
                pass: _passController.text,
                authType: AuthType.login,
              ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        ErrorMsg = e.message!;
      });
      print(ErrorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Log in",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                child: Image.asset("assets/manwithcomputer.png", scale: 20),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Email",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: "Enter your Email",
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.all(4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Email",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: _passController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "Password",
                    suffixIcon: Icon(Icons.visibility_off_outlined),
                    contentPadding: EdgeInsets.all(4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: Text(
                    "Forgot password?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: SignInWithEmailPass,
                child: CustomButton(value: "Log in"),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
