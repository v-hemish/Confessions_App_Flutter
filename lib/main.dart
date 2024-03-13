import 'package:anonymoose_confessions_app/auth/auth.dart';
import 'package:anonymoose_confessions_app/auth/login_or_register.dart';
import 'package:anonymoose_confessions_app/firebase_options.dart';
import 'package:anonymoose_confessions_app/pages/login_page.dart';
import 'package:anonymoose_confessions_app/pages/register_page.dart';
import 'package:anonymoose_confessions_app/theme/dark_mode.dart';
import 'package:anonymoose_confessions_app/theme/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: darkMode,
      darkTheme: darkMode,
    );
  }
}
