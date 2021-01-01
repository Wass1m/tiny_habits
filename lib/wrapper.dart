import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:tinyhabits/home/home.dart';
import 'package:tinyhabits/models/habit_provider.dart';
import 'package:tinyhabits/screens/auth/welcome_screen.dart';

class WrapperUser extends StatefulWidget {
  @override
  _WrapperUserState createState() => _WrapperUserState();
}

class _WrapperUserState extends State<WrapperUser> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    return user == null ? WelcomeScreen() : HomeScreen();
  }
}
