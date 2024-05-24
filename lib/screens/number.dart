import 'package:flight_app_ui/auth/otpapi.dart';
import 'package:flight_app_ui/screens/otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'otp_screen.dart'; // Import OtpScreen

class NumberScreen extends StatefulWidget {
  const NumberScreen({Key? key}) : super(key: key);

  @override
  _NumberScreenState createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff415a5c),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Form(
            key: _formKey,
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
                const SizedBox(
                  height: 18,
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xff415a5c),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Enter your Number',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Add your phone number. We'll send you a verification code so we know you're real",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 28,
                ),
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLength: 9,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefix: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '(+966)',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          suffixIcon: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 32,
                          ),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          } else if (value.length != 9) {
                            return 'Phone number must be 9 digits long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              String phoneNumber = '+966${_controller.text}';
                              sendOTP(context, phoneNumber);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OtpScreen(phoneNumber: phoneNumber),
                                ),
                              );
                            }
                          },
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xff415a5c)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xffffcfa1)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              'Send',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
