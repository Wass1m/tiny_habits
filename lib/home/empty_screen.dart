import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tinyhabits/home/edit_habit.dart';
import 'package:tinyhabits/models/goal.dart';
import 'package:tinyhabits/models/habit_provider.dart';
import 'package:tinyhabits/models/profile.dart';
import 'package:tinyhabits/screens/profile/profile.dart';
import 'package:tinyhabits/services/firebase/database.dart';
import 'package:tinyhabits/styles/styles.dart';

class EmptyScreen extends StatefulWidget {
  @override
  _EmptyScreenState createState() => _EmptyScreenState();
}

class _EmptyScreenState extends State<EmptyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        elevation: 35,
        onTap: (value) {
          setState(() {
            // HapticFeedback.vibrate();
          });

          // _pageController.jumpToPage(value);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
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
            icon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
      ),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: kPrimaryColor,
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/patternTrans.png',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/coffee.png',
                height: 200,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Empty Screen',
                        textAlign: TextAlign.center,
                        style: BigBoldHeading.copyWith(fontSize: 29)),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '      Add your device when Drip by Morning Co. gets released!',
                      textAlign: TextAlign.center,
                      style: GreySubtitle.copyWith(
                          fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Image(
                  image: AssetImage(
                    'assets/images/clickHere.png',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NoHabit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SvgPicture.asset(
              'assets/images/coffee-machine.svg',
              height: 200,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Empty Screen',
                      textAlign: TextAlign.center,
                      style: BigBoldHeading.copyWith(fontSize: 29)),
                  SizedBox(
                    height: 10,
                  ),
                  // Text(
                  //   'Your current habits will come here, create \n one by tapping on the plus button!',
                  //   textAlign: TextAlign.center,
                  //   style: GreySubtitle.copyWith(
                  //       fontSize: 16, color: Colors.black54),
                  // ),
                  Text(
                    '      Add your device when Drip by Morning Co. gets released!',
                    textAlign: TextAlign.center,
                    style: GreySubtitle.copyWith(
                        fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Image(
              image: AssetImage(
                'assets/images/clickHere.png',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
