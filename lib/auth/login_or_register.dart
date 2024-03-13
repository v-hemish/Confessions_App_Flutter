import 'package:anonymoose_confessions_app/pages/login_page.dart';
import 'package:anonymoose_confessions_app/pages/register_page.dart';
import 'package:flutter/material.dart';


class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginTrue = true;

  void togglePages(){
    setState(() {
      showLoginTrue = !showLoginTrue;
    });

  }
  @override
  Widget build(BuildContext context) {
    if(showLoginTrue){
      return LoginPage(onTap: togglePages);
    }
    else{
      return RegisterPage(onTap: togglePages);
    }
  }
}
