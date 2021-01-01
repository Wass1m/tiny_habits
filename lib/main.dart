import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinyhabits/models/habit_provider.dart';
import 'package:tinyhabits/models/habit_provider.dart';
import 'package:tinyhabits/models/profile.dart';
import 'package:tinyhabits/screens/auth/welcome_screen.dart';
import 'package:tinyhabits/services/firebase/auth.dart';
import 'package:tinyhabits/services/firebase/global.dart';
import 'package:tinyhabits/styles/theme.dart';
import 'package:tinyhabits/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HabitProvider>(
          create: (context) => HabitProvider(),
        ),
        StreamProvider<User>.value(value: AuthService().user),
        StreamProvider<Profile>.value(value: Global.profileRef.documentStream),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData,
      home: WrapperUser(),
    );
  }
}
