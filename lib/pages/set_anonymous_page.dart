import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helper/helper_function.dart';
import 'package:anonymoose_confessions_app/components/my_botton.dart';
import '../components/my_textfield.dart';
import 'home_page.dart'; // Make sure to import your HomePage correctly

class SetAnonymousUsernamePage extends StatefulWidget {
  const SetAnonymousUsernamePage({Key? key}) : super(key: key);

  @override
  _SetAnonymousUsernamePageState createState() => _SetAnonymousUsernamePageState();
}

class _SetAnonymousUsernamePageState extends State<SetAnonymousUsernamePage> {
  final TextEditingController usernameController = TextEditingController();
  bool isSubmitting = false;

  void setAnonymousUsername() async {
    final String username = usernameController.text.trim();
    if (username.isEmpty) {
      displayMessageToUser('Username cannot be empty', context);
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    // Check if the username is unique
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        isSubmitting = false;
      });
      displayMessageToUser('Username is already taken. Please choose another one.', context);
    } else {
      // Username is unique, proceed to save it
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': username,
        }, SetOptions(merge: true));

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), // Assuming HomePage is your main app screen
              (Route<dynamic> route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Anonymous Username"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MyTextField(
              hintText: "Anonymous Username",
              obscureText: false,
              controller: usernameController,
            ),
            const SizedBox(height: 20),
            isSubmitting
                ? const CircularProgressIndicator()
                : MyButton(text: "Submit", onTap: setAnonymousUsername),
          ],
        ),
      ),
    );
  }
}
