import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import cached network image package
import 'package:flight_app_ui/screens/detail_screen.dart';
import 'package:flight_app_ui/widgets/animated_route.dart';
import 'package:flight_app_ui/widgets/show_up_animation.dart';
import 'package:flight_app_ui/widgets/text.dart';
import '../data/flight_data.dart';
import '../widgets/flight_card.dart';
import 'flightBooking/add_flight.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

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
              text: currentUser?.displayName ?? "Guest",
              color: Theme.of(context).primaryColor,
              overflow: TextOverflow.ellipsis,
            ),
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display user profile image
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: currentUser?.photoURL != null
                            ? CachedNetworkImage(
                                imageUrl: currentUser!.photoURL!,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                              )
                            : const Placeholder(), // Placeholder if user doesn't have a profile picture
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currentUser?.displayName ??
                            '', // Display user's display name
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        currentUser?.email ?? '', // Display user's email
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                // Handle profile navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Handle settings navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.airplanemode_inactive_sharp),
              title: const Text('Airline'),
              onTap: () {
                // Handle airline navigation
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rate the App'),
              onTap: () {
                // Handle app rating navigation
              },
            ),
          ],
        ),
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
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
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
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              data: flightList[index],
                              index: index,
                            ),
                          ));
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
          Navigator.of(context).push(MyCustomAnimatedRoute(
            enterWidget: const AddFlightScreen(),
          ));
        },
        child: Icon(
          Icons.add,
          size: 28,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
