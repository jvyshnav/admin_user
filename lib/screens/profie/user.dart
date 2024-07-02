import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  void displayMessageToUser(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (context, snapshot) {
          // Any error
          if (snapshot.hasError) {
            displayMessageToUser("Something went wrong", context);
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          // Show loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null) {
            return const Center(
              child: Text("No data"),
            );
          }

          // Get data
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userData = user.data() as Map<String, dynamic>;

              // Check if fields exist
              final username = userData.containsKey('username')
                  ? userData['username']
                  : 'No username';
              final email = userData.containsKey('email')
                  ? userData['email']
                  : 'No email';

              return ListTile(
                title: Text(username),
                subtitle: Text(email),
              );
            },
          );
        },
      ),
    );
  }
}
