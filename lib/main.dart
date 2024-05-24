import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flight_app_ui/Provider/otp_provider.dart';
import 'package:flight_app_ui/screens/login_screen.dart';
import 'package:flight_app_ui/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => OtpProvider(), // Correct Provider instance
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => const LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xff415a5c),
        indicatorColor: const Color(0xffffcfa1),
        canvasColor: const Color(0xff9dafb1),
        // Removed Provider.of<OtpProvider>(context).isDarkMode
        // Set brightness directly to Brightness.light
        brightness: Brightness.light,
      ),
      home: const SplashScreen(),
    );
  }
}
