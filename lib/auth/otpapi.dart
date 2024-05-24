import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flight_app_ui/screens/otp.dart';

Future<void> sendOTP(BuildContext context, String phoneNumber) async {
  String generateOTP() {
    Random random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  const apiKey =
      'eba5b28598fa0cf1e19c4119df3cc3d6-03099bf9-72b5-4d6a-9f2e-1cb105254cde';
  const infobipURL = 'https://8genv1.api.infobip.com/sms/1/text/single';

  String otp = generateOTP();

  try {
    final response = await http.post(
      Uri.parse(infobipURL),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'App $apiKey',
      },
      body: jsonEncode({
        'from': 'flutter_flight_app_ui', // Replace with your sender ID
        'to': phoneNumber, // Correctly using the passed phone number
        'text': 'Your OTP code is: $otp',
      }),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('OTP Sent Successfully');
      }
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              key: const Key("otp_screen"),
              phoneNumber: phoneNumber,
            ),
          ),
        );
      }
    } else {
      if (kDebugMode) {
        print('Failed to send OTP');
        print('Response Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send OTP. Please try again later.'),
          ),
        );
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error sending OTP: $e');
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }
}
