import 'package:clients/auth/auth.dart';
import 'package:clients/components/my_post_button.dart';
import 'package:clients/components/my_textfield.dart';
import 'package:clients/database/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/mydrawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Firestore database access
  final FirestoreDatabaseee database = FirestoreDatabaseee();
  final FirestoreDatabaseee db = FirestoreDatabaseee();




  final TextEditingController newPostController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Logout
  // Logout
  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut().then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully logged out')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $error')),
      );
    });
  }


  // Post message
  void postMessage() {
    if (newPostController.text.isNotEmpty &&  currentUser != null) {
      String message = newPostController.text;
      // database.addPost(message);
      db.addFieldToUserById(currentUser!.uid, "qualification", message);
    }
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Home"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout_outlined, size: 40),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MyTextField(
                      hintText: "say something",
                      controller: newPostController,
                    ),
                  ),
                  PostButton(
                    onTap: postMessage,
                  ),
                ],
              ),
            ),
            // Posts
            Expanded(
              child: currentUser == null
                  ? const Center(child: Text("No user logged in"))
                  : StreamBuilder(
                stream: database.getPostsByEmail(currentUser!.email ?? ''),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No posts...post something..."));
                  }

                  final posts = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      String message = post['postMessage'] ?? '';
                      String userEmail = post['userEmail'] ?? ''; // Ensure 'userEmail' is accessed correctly
                      // String timeStamp = (post['timeStamp'] as Timestamp).toDate().toString();

                      return ListTile(
                        title: Text(message),
                        subtitle: Text(userEmail),

                      );
                    },
                  );
                },
              ),

            ),
          ],
        ),
      ),
    );
  }
}
