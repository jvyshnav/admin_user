import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.inversePrimary,
              )),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("H O M E"),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("P R O F I L E"),
                  leading: const Icon(Icons.person),
                  onTap: () {
                   Navigator.pushNamed(context, '/profile_page');
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("U S E R S"),
                  leading: const Icon(Icons.group),
                  onTap: () {
                    Navigator.pushNamed(context, '/user_page');
                  },
                ),
              ),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 25.0,bottom: 25),
          //   child: ListTile(
          //     title: Text("L O G O U T"),
          //     leading: Icon(Icons.home  ),
          //     onTap: () {
          //       Navigator.pop(context);
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
