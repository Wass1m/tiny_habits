import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tinyhabits/helpers/toast.dart';
import 'package:tinyhabits/models/goal.dart';
import 'package:tinyhabits/services/firebase/auth.dart';
import 'package:tinyhabits/services/firebase/global.dart';
import 'package:tinyhabits/styles/styles.dart';

class CreateHabit extends StatefulWidget {
  @override
  _CreateHabitState createState() => _CreateHabitState();
}

class _CreateHabitState extends State<CreateHabit> {
  AuthService _auth = AuthService();
  List<String> _afterpropostions = [
    'Bursh my teeth',
    'had dinner',
    'finish my gym',
    'read my book'
  ];

  List<String> _willpropostions = [
    'Meditate for 5 mins',
    'Go for a walk',
    'Read for 30 mins',
    'Buy groceries'
  ];

  bool loading = false;

  List<int> dates = [];

  List<Color> _colors = [
    Color(
      0xFFFDE3E2,
    ),
    Color(0xFFC5E3FE),
    Color(0xFFD8EFEF),
    Color(0xFFFDE0BE)
  ];

  Color _selectedColor = Color(
    0xFFFDE3E2,
  );

  final _formKey = GlobalKey<FormState>();
  TextEditingController _after = TextEditingController();

  TextEditingController _will = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      Text('New Habit', style: BigBoldHeading),
                      Container(),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Today I want to,',
                    style: SansHeading,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _after,
                    autofillHints: [
                      AutofillHints.name,
                    ],
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Habit',
                    ),
                    validator: (value) {
                      if (value == '') {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _afterpropostions.length,
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _after.text = _afterpropostions[index];
                                });
                              },
                              child: DottedBorder(
                                color: Colors.grey,
                                strokeWidth: 1,
                                borderType: BorderType.RRect,
                                radius: Radius.circular(30),
                                padding: EdgeInsets.all(16),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(_afterpropostions[index])),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Then, I will,',
                    style: SansHeading,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _will,
                    autofillHints: [
                      AutofillHints.name,
                    ],
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Will do habit',
                    ),
                    validator: (value) {
                      if (value == '') {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _willpropostions.length,
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _will.text = _willpropostions[index];
                                });
                              },
                              child: DottedBorder(
                                color: Colors.grey,
                                strokeWidth: 1,
                                borderType: BorderType.RRect,
                                radius: Radius.circular(30),
                                padding: EdgeInsets.all(16),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(_willpropostions[index])),
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Text(
                  //   'Click on days to remember,',
                  //   style: SansHeading,
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  // Container(
                  //   height: 50,
                  //   child: ListView.builder(
                  //     itemCount: 7,
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: (ctx, f) {
                  //       int day = DateTime.now().day + f;
                  //
                  //       return FittedBox(
                  //         child: GestureDetector(
                  //           onTap: () {
                  //             if (dates.indexOf(f) < 0) {
                  //               setState(() {
                  //                 dates.add(f);
                  //               });
                  //             } else {
                  //               setState(() {
                  //                 dates.remove(f);
                  //               });
                  //             }
                  //             print(dates);
                  //           },
                  //           child: Container(
                  //             margin: EdgeInsets.only(right: 15.0),
                  //             padding:
                  //                 EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  //             alignment: Alignment.center,
                  //             decoration: BoxDecoration(
                  //               color: dates.indexOf(f) > -1
                  //                   ? kPrimaryColor
                  //                   : Colors.grey.withOpacity(0.2),
                  //               borderRadius: BorderRadius.circular(30.0),
                  //             ),
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: <Widget>[
                  //                 // Text(
                  //                 //   "${DateTime.now().day + f}",
                  //                 //   style: TextStyle(
                  //                 //     fontSize: 25,
                  //                 //     fontWeight: day == DateTime.now().day
                  //                 //         ? FontWeight.bold
                  //                 //         : FontWeight.normal,
                  //                 //     color: day == DateTime.now().day
                  //                 //         ? Colors.white
                  //                 //         : Colors.grey[500],
                  //                 //   ),
                  //                 // ),
                  //                 Text(
                  //                   DateFormat('EE').format(
                  //                     DateTime.now().add(
                  //                       Duration(days: f),
                  //                     ),
                  //                   ),
                  //                   style: TextStyle(
                  //                       color: day == DateTime.now().day
                  //                           ? Colors.black
                  //                           : dates.indexOf(f) > -1
                  //                               ? Colors.white
                  //                               : Colors.grey[700],
                  //                       fontWeight: day == DateTime.now().day
                  //                           ? FontWeight.bold
                  //                           : FontWeight.normal,
                  //                       fontSize: 10),
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Select Label color,',
                    style: SansHeading,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _colors.length,
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = _colors[index];
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundColor:
                                      _selectedColor == _colors[index]
                                          ? kPrimaryColor
                                          : Colors.white,
                                  radius: 17,
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: _colors[index],
                                  ),
                                )),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  loading == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          child: RaisedButton(
                            elevation: 0,
                            textColor: Colors.white,
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });

                              if (!_formKey.currentState.validate()) {
                                setState(() {
                                  loading = false;
                                });
                                return;
                              }

                              var user =
                                  Provider.of<User>(context, listen: false);

                              // List<DateGoal> goals = dates
                              //     .map((e) => DateGoal(
                              //           date: DateTime.now().add(
                              //             Duration(days: e),
                              //           ),
                              //           status: false,
                              //         ))
                              //     .toList();

                              var time = DateTime.now();
                              var goal = Habit(
                                name: _after.text,
                                will: _will.text,
                                owner: user.uid,
                                dateGoals: [],
                                color: _selectedColor.value,
                                startDate: DateTime(time.year, time.month,
                                    time.day, 12, 0, 0, 0, 0),
                              );

                              await Global.habitRef.upsert(goal.toMap());

                              // print(_selectedColor.v);

                              toast('New Habit Successfully Added');

                              setState(() {
                                loading = false;
                              });

                              // Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(),
                                Text('Create New Habit'),
                                Icon(Icons.exit_to_app)
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
