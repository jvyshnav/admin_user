import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabaseee {
  final User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference posts =
  FirebaseFirestore.instance.collection("Users");

  Future<void> addPost(String message) {
    if (user != null) {
      return posts.add({
        'userEmail': user!.email, // Use 'userEmail' to match your Firestore field
        'postMessage': message,
        'timeStamp': Timestamp.now(),
      });
    } else {
      throw Exception("User not logged in");
    }
  }


  //add field to existing user
  Future<void> addFieldToUserById(String userId, String fieldName, dynamic fieldValue) async {
    try {
      DocumentReference docRef = posts.doc(userId);
      await docRef.update({
        fieldName: fieldValue,
      });
    } catch (error) {
      print("Failed to update document: $error");
    }
  }


  Stream<QuerySnapshot> getPostsStream() {
    return posts
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }
  Stream<QuerySnapshot> getPostsByEmail(String email) {
    return posts.where('userEmail', isEqualTo: email).snapshots();
  }



}
