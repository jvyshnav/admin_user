import 'package:clients/components/my_textfield.dart';
import 'package:clients/components/mybutton.dart';
import 'package:clients/screens/signup/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key, this.onTap});

  final void Function()? onTap;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void login() async {
    showDialog(context: context,
      builder: (context) => const Center(child: CircularProgressIndicator(),),);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      if(context.mounted) Navigator.pop(context);
    }
    on FirebaseAuthException catch(e){
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
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
              SizedBox(
                height: 10,
              ),
              Text("M I N I M A L"),
              SizedBox(
                height: 25,
              ),

              MyTextField(hintText: "email", controller: emailController),
              SizedBox(
                height: 10,
              ),
              MyTextField(
                hintText: "password",
                controller: passwordController,
                obscureText: true,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password ?",
                    style: TextStyle(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .secondary,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              MyButton(
                text: "Login ",
                onTap: login,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account ?",
                    style: TextStyle(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .secondary,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap:widget.onTap,
                    //     () {
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => RegisterPage(),
                    //       ));
                    // },
                    child: Text(
                      "Register Now",
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
