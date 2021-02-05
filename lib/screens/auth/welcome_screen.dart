import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tinyhabits/styles/styles.dart';

import 'login.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Image(
                    image: AssetImage(
                      'assets/images/logoMorning.jpg',
                    ),
                  ),
                  Text('Rise and Grind',
                      textAlign: TextAlign.center,
                      style: BigBoldHeading.copyWith(fontSize: 20)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Start setting goals',
                      textAlign: TextAlign.center,
                      style: BigBoldHeading.copyWith(fontSize: 29)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Track your progress \n and keep going!',
                    textAlign: TextAlign.center,
                    style: GreySubtitle.copyWith(fontSize: 16),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 2.0,
                            spreadRadius: 0.0,
                            offset:
                                Offset(0, 0), // shadow direction: bottom right
                          )
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment
                              .centerRight, // 10% of the width, so there are ten blinds.
                          colors: [DarkNavyBlue, DarkNavyBlue], // red to yellow
                          tileMode: TileMode
                              .repeated, // repeats the gradient over the canvas
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          Text('Get Started!',
                              style: WhiteSansHeading.copyWith(fontSize: 16)),
                          Container(),
                          // Icon(
                          //   Icons.arrow_right_alt,
                          //   size: 30,
                          //   color: Colors.white,
                          // ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
