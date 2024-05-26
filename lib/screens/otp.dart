import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flight_app_ui/Provider/otp_provider.dart';
import 'home_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  OtpScreenState createState() => OtpScreenState();
}

class OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();

  String _combinedOtp = '';
  int _timerCount = 5;
  late Timer _timer;

  void _startTimer() {
    _timerCount = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_timerCount == 0) {
        timer.cancel();
      } else {
        setState(() {
          _timerCount--;
        });
      }
    });
  }

  void _resendOtp() {
    final otpProvider = Provider.of<OtpProvider>(context, listen: false);
    otpProvider.resendOTP(context, widget.phoneNumber).then((_) {
      _startTimer();
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController1.dispose();
    _otpController2.dispose();
    _otpController3.dispose();
    _otpController4.dispose();
    super.dispose();
  }

  void _updateCombinedOtp() {
    setState(() {
      _combinedOtp = _otpController1.text +
          _otpController2.text +
          _otpController3.text +
          _otpController4.text;
    });
  }

  void _verifyOtp() {
    _updateCombinedOtp();
    String enteredOTP = _combinedOtp;

    if (enteredOTP.length == 4) {
      final otpProvider = Provider.of<OtpProvider>(context, listen: false);
      bool isCorrectOTP = otpProvider.validateOTP(enteredOTP);

      if (isCorrectOTP) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect OTP. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid OTP.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff415a5c),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xff415a5c),
                  ),
                  child: Image.asset('assets/logo.png'),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Verification',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter your OTP code number",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Phone Number: ${widget.phoneNumber}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                _timerCount > 0
                    ? Text(
                        'Resend OTP in $_timerCount seconds',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : GestureDetector(
                        onTap: _resendOtp,
                        child: const Text(
                          "Resend OTP",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: _buildOTPTextField(_otpController1,
                                  isFirst: true)),
                          const SizedBox(width: 8),
                          Expanded(child: _buildOTPTextField(_otpController2)),
                          const SizedBox(width: 8),
                          Expanded(child: _buildOTPTextField(_otpController3)),
                          const SizedBox(width: 8),
                          Expanded(
                              child: _buildOTPTextField(_otpController4,
                                  isLast: true)),
                        ],
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _verifyOtp,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xffffcfa1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              'Verify',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: _resendOtp,
                  child: const Text(
                    "Didn't you receive any code?",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOTPTextField(TextEditingController controller,
      {bool isFirst = false, bool isLast = false}) {
    return TextField(
      controller: controller,
      autofocus: isFirst,
      onChanged: (value) {
        if (value.length == 1 && !isLast) {
          FocusScope.of(context).nextFocus();
        } else if (value.isEmpty && !isFirst) {
          FocusScope.of(context).previousFocus();
        }
        _updateCombinedOtp();
      },
      showCursor: false,
      readOnly: false,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      keyboardType: TextInputType.number,
      maxLength: 1,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        counter: const Offstage(),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Colors.black12),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: Color(0xffffcfa1)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
