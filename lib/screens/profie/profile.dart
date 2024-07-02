import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic>? user = snapshot.data!.data();
            if (user != null) {
              return Center(
                child: Column(
                  children: [
                    Text(user['email'] ?? 'No email available'),
                    Text(user['username'] ?? 'No username available'),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text("User data not available"),
              );
            }
          } else {
            return const Center(
              child: Text("No data"),
            );
          }
        },
      ),
    );
  }
}
