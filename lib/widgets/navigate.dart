import 'package:flight_app_ui/screens/login_screen.dart';
import 'package:flight_app_ui/screens/number.dart';
import 'package:flight_app_ui/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Navigate extends StatelessWidget {
  final User? currentUser;

  const Navigate({Key? key, this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.airplanemode_inactive_sharp),
          label: 'Airline',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Rate the App',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            // Handle profile navigation
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const LoginScreen()), // Assuming SettingsScreen is your settings page
            );
            break;
          case 2:
            // Handle airline navigation
            break;
          case 3:
            // Handle app rating navigation
            break;
          case 4:
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacementNamed('/login');
            break;
        }
      },
    );
  }
}
