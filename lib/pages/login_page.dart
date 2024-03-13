import 'package:anonymoose_confessions_app/components/my_botton.dart';
import 'package:anonymoose_confessions_app/components/my_textfield.dart';
import 'package:anonymoose_confessions_app/helper/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  void Function()? onTap;

  LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void login() async{
    // show loadng circle
  showDialog(context: context, builder: (context) => const Center(
    child: CircularProgressIndicator(),
  ),);

  try{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
    if(context.mounted) Navigator.pop(context);
  }
    on FirebaseAuthException catch (e){
    Navigator.pop(context);
    displayMessageToUser(e.code, context);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context)
                    .colorScheme
                    .onPrimary, // Adjusted to onPrimary
              ),
              const SizedBox(height: 25),
              //title of the app
              const Text(
                'C O N F E S S I O N S',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 75),
              //email address text field
              MyTextField(
                hintText: "Email Address ...",
                obscureText: false,
                controller: emailController,
              ),
              // Sized box
              const SizedBox(height: 15),
              //password textfield
              MyTextField(
                hintText: "Password ...",
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSecondary, // Adjusted to onSecondary
                    ),
                  ),
                ],
              ),
              //sign in
              const SizedBox(height: 25),
              MyButton(text: "Login", onTap: login),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary, // Adjusted to onPrimary
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Register Here",
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
