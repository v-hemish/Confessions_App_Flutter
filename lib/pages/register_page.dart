import 'package:anonymoose_confessions_app/components/my_botton.dart';
import 'package:anonymoose_confessions_app/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helper/helper_function.dart';

class RegisterPage extends StatefulWidget {
  void Function()? onTap;

  RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {


  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController = TextEditingController();

  void register() async {
    // show loading circle
    showDialog(context: context, builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
    );
    // make sure passwords match
    if(passwordController.text != confirmPasswordController.text){
      Navigator.pop(context);
      displayMessageToUser("Invalid Password", context);
    }
    // try creating the user
    try{
      UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      Navigator.pop(context);

    } on FirebaseAuthException catch (e){
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
              // Sized box
              const SizedBox(height: 15),
              MyTextField(
                hintText: "Email..",
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
              const SizedBox(height: 15),
              MyTextField(
                hintText: "Confirm Password..",
                obscureText: true,
                controller: confirmPasswordController,
              ),
              // Sized box
              const SizedBox(height: 15),

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
              MyButton(text: "Register", onTap: register),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary, // Adjusted to onPrimary
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      "Login Here",
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
