import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:flight_app_ui/screens/login_screen.dart'; // Import the LoginScreen

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  Future<void> _resetPassword() async {
    String email = _emailController.text.trim();
    if (email.isNotEmpty) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent to $email')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error sending reset email')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Hero(
                      tag: "logo",
                      child: SizedBox(
                        height: 130,
                        width: 130,
                        child: Image.asset(
                          "assets/logo.png",
                          color: Theme.of(context).indicatorColor,
                        ),
                      ),
                    ),
                  ),
                  Field(
                    controller: _emailController,
                    hinttext: "E-MAIL",
                    icon: Icons.alternate_email,
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _resetPassword, // Call _resetPassword on tap
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).indicatorColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      child: TextUtil(
                        text: "Reset Password",
                        weight: true,
                        color: Theme.of(context).primaryColor,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  RichText(
                    text: TextSpan(
                      text: 'back ?',
                      style: TextStyle(
                        color: Theme.of(context).canvasColor,
                        fontSize: 14,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'LoginScreen',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).indicatorColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Transform.rotate(
                angle: 6,
                child: const Icon(
                  Icons.flight_takeoff,
                  size: 100,
                  color: Color(0xff3a5455),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Field extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;
  final IconData icon;

  const Field({
    Key? key,
    required this.controller,
    required this.hinttext,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Theme.of(context).indicatorColor),
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: TextStyle(color: Theme.of(context).indicatorColor),
        prefixIcon: Icon(icon, color: Theme.of(context).indicatorColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).indicatorColor),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).indicatorColor),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

class TextUtil extends StatelessWidget {
  final String text;
  final bool weight;
  final double size;
  final Color? color;
  final VoidCallback? onTap;

  const TextUtil({
    Key? key,
    required this.text,
    this.weight = false,
    this.size = 14,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: size,
          color: color ?? Theme.of(context).canvasColor,
          fontWeight: weight ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
