import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    // Define the spacing value you want between the icon and text
    final double iconTextSpacing = 16.0; // Adjust this value as needed

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: IconButton(
              icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.primary), // Set color to primary
              onPressed: () {
                // Handle drawer icon press
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: SizedBox(
                width: 24, // Maintain a specific width for the icon
                child: Icon(Icons.home, color: Theme.of(context).colorScheme.onPrimary), // Change color to onPrimary
              ),
              title: const Text("H O M E"),
              horizontalTitleGap: iconTextSpacing, // Apply the spacing value here
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: SizedBox(
                width: 24, // Maintain a specific width for the icon
                child: Icon(Icons.person, color: Theme.of(context).colorScheme.onPrimary), // Change color to onPrimary
              ),
              title: const Text("P R O F I L E"),
              horizontalTitleGap: iconTextSpacing, // Apply the spacing value here
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: ListTile(
              leading: SizedBox(
                width: 24, // Maintain a specific width for the icon
                child: Icon(Icons.group, color: Theme.of(context).colorScheme.onPrimary), // Change color to onPrimary
              ),
              title: const Text("U S E R S"),
              horizontalTitleGap: iconTextSpacing, // Apply the spacing value here
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Spacer(), // Pushes the following widget to the bottom
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 20.0),
            child: ListTile(
              leading: SizedBox(
                width: 24, // Maintain a specific width for the icon
                child: Icon(Icons.logout, color: Theme.of(context).colorScheme.onPrimary), // Change color to onPrimary
              ),
              title: const Text("L O G O U T"),
              horizontalTitleGap: iconTextSpacing, // Apply the spacing value here
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
