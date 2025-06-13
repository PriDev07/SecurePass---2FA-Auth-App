import 'dart:convert';

import 'package:http/http.dart' as http;

class MailService {
  //To send mail to the user when they click button
  Future<void> sendOtpEmail(String email, String otp) async {
    final response = await http.post(
      Uri.parse("https://securepass-2fa-auth-app.onrender.com/send-otp"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );
    if (response.statusCode == 200) {
    print("OTP sent successfully!");
  } else {
    print("Failed to send OTP: ${response.body}");
  }
  }
}
