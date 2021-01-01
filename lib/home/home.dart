import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tinyhabits/home/all_habits.dart';
import 'package:tinyhabits/home/create_habit.dart';
import 'package:tinyhabits/home/today_habits.dart';
import 'package:tinyhabits/styles/styles.dart';

class HomeScreen extends StatefulWidget {
  static const routename = "/home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  // PageController _pageController = PageController();

  String userId;

  List<Widget> screens = [
    TodayHabit(),
    CreateHabit(),
    Calendar(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        elevation: 35,
        onTap: (value) {
          setState(() {
            HapticFeedback.vibrate();
            _currentIndex = value;
          });

          // _pageController.jumpToPage(value);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
                radius: 25,
                backgroundColor: kPrimaryColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                )),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}
