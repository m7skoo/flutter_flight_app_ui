import 'package:flight_app_ui/widgets/navigate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flight_app_ui/screens/detail_screen.dart';
import 'package:flight_app_ui/widgets/animated_route.dart';
import 'package:flight_app_ui/widgets/show_up_animation.dart';
import 'package:flight_app_ui/widgets/text.dart';
import '../data/flight_data.dart';
import '../widgets/flight_card.dart';
import 'flightBooking/add_flight.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextUtil(
              text: "Welcome Back!",
              color: Theme.of(context).primaryColor,
              size: 12,
              weight: true,
              overflow: TextOverflow.ellipsis,
            ),
            TextUtil(
              text: _currentUser?.displayName ?? "Guest",
              color: Theme.of(context).primaryColor,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.account_tree,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            height: 60,
            alignment: Alignment.centerLeft,
            child: TextUtil(
              text: "My flights",
              color: Theme.of(context).primaryColor,
              weight: true,
              size: 28,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ListView.builder(
                  itemCount: flightList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ShowUpAnimation(
                      delay: 150 * index,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                data: flightList[index],
                                index: index,
                              ),
                            ),
                          );
                        },
                        child: FlightCard(
                          data: flightList[index],
                          index: index,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).indicatorColor,
        onPressed: () {
          Navigator.of(context).push(
            MyCustomAnimatedRoute(
              enterWidget: const AddFlightScreen(),
            ),
          );
        },
        child: Icon(
          Icons.add,
          size: 28,
          color: Theme.of(context).primaryColor,
        ),
      ),
      bottomNavigationBar: Navigate(currentUser: _currentUser),
    );
  }
}
