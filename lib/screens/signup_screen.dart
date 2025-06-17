import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:securepass/screens/login_screen.dart';
import 'package:securepass/screens/otp_screen.dart';
import 'package:securepass/services/auth_service.dart';
import 'package:securepass/services/mail_service.dart';
import 'package:securepass/widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String ErrorMsg = "";
  final Random _random = Random();
  int _randomNumber = 0;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //OTP generation method
    void generateRandomNumber() {
      setState(() {
        _randomNumber = 1000 + _random.nextInt(9000);
      });
    }
    // Create user function
    Future<void> createUserWithEmailPass() async {
      try {
        generateRandomNumber();
        await MailService().sendOtpEmail(
          _emailController.text,
          _randomNumber.toString(),
        );
        await fb().addOtp(
          email: _emailController.text,
          Otp: _randomNumber.toString(),
        );
        await fb().checkotp(
          email: _emailController.text,
          enteredOtp: _randomNumber.toString(),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (builder) => OtpScreen(
                  email: _emailController.text,
                  pass: _passController.text,
                  authType: AuthType.signup,
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
                  "Sign up",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 100),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Enter your Email to sign up",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 50),
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
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "",
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
                    prefixIcon: Icon(Icons.email),
                    hintText: "password",
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.all(4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
              GestureDetector(
                onTap: createUserWithEmailPass,
                child: CustomButton(value: "Continue"),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      "Log in",
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
