import 'package:flutter/material.dart';
import 'package:securepass/screens/profile_screen.dart';
import 'package:securepass/services/auth_service.dart';
import 'package:securepass/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
enum AuthType {
  signup,
  login,
}


class OtpScreen extends StatefulWidget {
  String email;
  String pass;
  final AuthType authType;

  OtpScreen({super.key, required this.email, required this.pass,required this.authType});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < _focusNodes.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    }
  }
//OTP verification method
  Future<void> verifyOtp() async {
  String otp = _controllers.map((c) => c.text).join();

  if (otp.length != 4) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter complete 4-digit OTP")),
    );
    return;
  }

  bool isValid = await fb().checkotp(email: widget.email, enteredOtp: otp);

  if (isValid) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("OTP verified! Logging in...")),
    );

    try {
      if (widget.authType == AuthType.signup) {
        await fb().createUserWithEmailAndPassword(
          email: widget.email,
          pass: widget.pass,
        );
      } else {
        await fb().signInwithemailPass(
          email: widget.email,
          pass: widget.pass,
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication failed: $e")),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Invalid OTP")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Icon(Icons.arrow_back_ios_new)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                "We just sent a mail",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("Enter the security code we sent to",
                  style: TextStyle(fontSize: 19)),
              const SizedBox(height: 10),
              Text(widget.email, style: TextStyle(fontSize: 16)),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue.shade700),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        onChanged: (value) => _onChanged(value, index),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 30),
              CustomButton(value: "Verify", onTap: verifyOtp),
              const SizedBox(height: 20),
              const Text("Didn't receive code?", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  // This feature will come soon
                },
                child: Text(
                  "Resend",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
