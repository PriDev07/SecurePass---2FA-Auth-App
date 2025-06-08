import 'package:flutter/material.dart';
import 'package:securepass/screens/login_screen.dart';
import 'package:securepass/screens/otp_screen.dart';
import 'package:securepass/screens/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: OtpScreen(email: "Lohaniprince72@gmail.com"),
    );
  }
}
