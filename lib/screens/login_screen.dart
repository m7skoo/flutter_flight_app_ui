import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flight_app_ui/screens/forget_password.dart';
import 'package:flight_app_ui/screens/home_screen.dart';
import 'package:flight_app_ui/screens/register.dart';
import '../auth/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password.')),
      );
      return;
    }

    try {
      final user =
          await _authService.loginUserWithEmailAndPassword(email, password);
      if (user != null && user.emailVerified) {
        _emailController.clear();
        _passwordController.clear();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Email not verified. Please check your inbox to verify.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed. Please check your credentials.';
      if (e.code == 'email-not-verified') {
        message = 'Email is not verified. Please verify your email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.')),
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
                  Field(
                    controller: _passwordController,
                    hinttext: "PASSWORD",
                    icon: Icons.lock,
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).indicatorColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: TextUtil(
                      text: "Forgot Password?",
                      weight: true,
                      size: 14,
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const ForgetPasswordScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: _loginUser,
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).indicatorColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      child: TextUtil(
                        text: "Log in",
                        weight: true,
                        color: Theme.of(context).primaryColor,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  RichText(
                    text: TextSpan(
                      text: 'You don\'t have an account?',
                      style: TextStyle(
                        color: Theme.of(context).canvasColor,
                        fontSize: 14,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: ' Register now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).indicatorColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
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
  final bool obscureText;
  final Widget? suffixIcon;

  const Field({
    Key? key,
    required this.controller,
    required this.hinttext,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Theme.of(context).indicatorColor),
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hinttext,
        hintStyle: TextStyle(color: Theme.of(context).indicatorColor),
        prefixIcon: Icon(icon, color: Theme.of(context).indicatorColor),
        suffixIcon: suffixIcon,
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
  });

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
