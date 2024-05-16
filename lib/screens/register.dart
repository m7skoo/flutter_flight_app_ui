import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flight_app_ui/screens/login_screen.dart';
import '../auth/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();
  bool _isPasswordVisible = false;

  void _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty) {
      _showError("Email cannot be empty");
      return;
    }
    if (password.isEmpty) {
      _showError("Password cannot be empty");
      return;
    }
    if (confirmPassword.isEmpty) {
      _showError("Confirmation password cannot be empty");
      return;
    }
    if (password != confirmPassword) {
      _showError("Passwords do not match");
      return;
    }

    try {
      await _authService.registerUserWithEmailAndPassword(email, password);
      _showSuccess("Registration successful! Please verify your email.");
    } catch (e) {
      _showError("Registration failed: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                    controller: _firstNameController,
                    hinttext: "FIRST NAME",
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  Field(
                    controller: _phoneController,
                    hinttext: "PHONE NUMBER",
                    icon: Icons.phone,
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  Field(
                    controller: _confirmPasswordController,
                    hinttext: "CONFIRM PASSWORD",
                    icon: Icons.lock_outline,
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
                  GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      _register();
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).indicatorColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      child: TextUtil(
                        text: "Register Now",
                        weight: true,
                        color: Theme.of(context).primaryColor,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  RichText(
                    text: TextSpan(
                      text: ' have an account? ',
                      style: TextStyle(
                        color: Theme.of(context).canvasColor,
                        fontSize: 14,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Log in',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).indicatorColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
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
    super.key,
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
