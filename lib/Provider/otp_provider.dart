import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpProvider with ChangeNotifier {
  String _otp = '';

  String generateOTP() {
    Random random = Random();
    _otp = (1000 + random.nextInt(9000)).toString();
    notifyListeners();
    return _otp;
  }

  bool validateOTP(String enteredOTP) {
    return enteredOTP == _otp;
  }

  Future<void> resendOTP(BuildContext context, String phoneNumber) async {
    String newOTP = generateOTP();

    const apiKey =
        'eba5b28598fa0cf1e19c4119df3cc3d6-03099bf9-72b5-4d6a-9f2e-1cb105254cde';
    const infobipURL = 'https://8genv1.api.infobip.com/sms/1/text/single';

    final response = await http.post(
      Uri.parse(infobipURL),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'App $apiKey',
      },
      body: jsonEncode({
        'from': 'flutter_flight_app_ui',
        'to': phoneNumber,
        'text': 'Your OTP code is: $newOTP',
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP Sent Successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send OTP. Please try again later.'),
        ),
      );
    }
  }
}
