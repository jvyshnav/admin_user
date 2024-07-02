import 'package:clients/components/my_textfield.dart';
import 'package:clients/components/mybutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';


class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

   const RegisterPage({super.key, this.onTap});



  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController userController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmController = TextEditingController();


  Future<void> registerUser() async {
    // Show loading indicator
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Check if passwords match
    if (confirmController.text != passwordController.text) {
      Navigator.pop(context); // Dismiss loading indicator
      displayMessageToUser("Passwords don't match!", context);
      return;
    }

    else{


      try {
        //  create the user
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        //create user documents and store in database
        createUserDocument(userCredential);


        // Registration successful, dismiss loading indicator
        Navigator.pop(context);

        // Optionally, navigate to another screen or perform other actions
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context); // Dismiss loading indicator

        // Handle specific errors
        String errorMessage = 'Unknown error occurred';
        switch (e.code) {
          case 'weak-password':
            errorMessage = 'The password provided is too weak.';
            break;
          case 'email-already-in-use':
            errorMessage = 'The account already exists for that email.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
        // Handle more Firebase Auth exceptions as needed...
          default:
            errorMessage = e.message ?? errorMessage;
        }

        // Display error message to user
        displayMessageToUser(errorMessage, context);
      } catch (e) {
        // Handle other exceptions
        print('Error occurred: $e');
        displayMessageToUser('Unknown error occurred', context);
      }
    }
  }
  //create user and store data in firestore

  Future<void>createUserDocument(UserCredential? userCredential)async{
    if(userCredential!=null && userCredential.user!=null){
    await FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.uid).set({
      'email': userCredential.user!.email,
      'username':userController.text,
      'userid':userCredential.user!.uid,
    });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 85,
                color: Theme
                    .of(context)
                    .colorScheme
                    .inversePrimary,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("M I N I M A L"),
              const SizedBox(
                height: 15,
              ),
              MyTextField(hintText: "username", controller: userController),
              MyTextField(hintText: "email", controller: emailController),
              MyTextField(
                hintText: "password",
                controller: passwordController,
                obscureText: true,
              ),
              MyTextField(
                hintText: "Confirm password",
                controller: confirmController,
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              MyButton(
                text: "Register ",
                onTap: registerUser,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account ?",
                    style: TextStyle(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .secondary,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Login Now",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


void displayMessageToUser(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
          title: Text(message),
        ),
  );
}