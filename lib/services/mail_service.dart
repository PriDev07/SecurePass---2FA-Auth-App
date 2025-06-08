import 'dart:convert';

import 'package:http/http.dart' as http;

class MailService {
  Future<void> sendOtpEmail(String email, String otp) async {
    final response = await http.post(
      Uri.parse("http://192.168.29.119:3000/send-otp"),
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
