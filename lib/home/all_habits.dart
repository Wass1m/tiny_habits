import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:table_calendar/table_calendar.dart';
import 'package:tinyhabits/home/empty_screen.dart';
import 'package:tinyhabits/home/habit_stats.dart';
import 'package:tinyhabits/models/goal.dart';
import 'package:tinyhabits/services/firebase/auth.dart';
import 'package:tinyhabits/services/firebase/global.dart';
import 'package:tinyhabits/styles/styles.dart';
import 'package:tinyhabits/wrapper.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController _calendarController;
  DateTime dayCalendar = DateTime.now();
  var aptRef = Global.habitRef;
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    var datef = DateFormat('dd-MM-yyyy');
    // print(salon.id);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder(
                future: aptRef.getDataById('owner', user.uid),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List<Habit> habits = snapshot.data;
                    print(habits);
                    return TableCalendar(
                      initialCalendarFormat: CalendarFormat.week,
                      startingDayOfWeek: StartingDayOfWeek.sunday,
                      builders: CalendarBuilders(
                          dayBuilder: (BuildContext context, date, events) {
                        var currentDateHabits = habits.where(
                          (element) => date.isAfter(
                            element.startDate,
                          ),
                        );

                        List<Habit> completed = [];
                        List<Habit> pending = [];

                        var startToday = DateTime(
                            date.year, date.month, date.day, 0, 0, 0, 0, 0);

                        var endToday = DateTime(
                            date.year, date.month, date.day, 23, 59, 59, 0, 0);

                        currentDateHabits.forEach((habit) {
                          var exists = habit.dateGoals.indexWhere((element) =>
                              element.date.isAfter(startToday) &&
                              element.date.isBefore(endToday));
                          print(exists);
                          if (exists >= 0) {
                            completed.add(habit);
                          } else
                            pending.add(habit);
                          return habit;
                        });

                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color:
                                    completed.length == currentDateHabits.length
                                        ? Color(0xff90ee90)
                                        : completed.length > 0
                                            ? Colors.yellow.withOpacity(0.7)
                                            : Colors.red.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(
                                  40,
                                )),
                            child: Text(date.day.toString()),
                          ),
                        );
                      }),
                      onDaySelected: (date, events, options) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HabitStats(
                              selectedDate: date,
                            ),
                          ),
                        );
                      },
                      calendarStyle: CalendarStyle(
                        todayColor: StarYellow,
                        selectedColor: Colors.red,
                      ),
                      calendarController: _calendarController,
                    );
                  } else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                },
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0, bottom: 40),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmptyScreen(),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/coffee-cup.svg',
                        height: 180,
                      ),
                    ),
                  ),
                ),
              ),

              // Expanded(
              //     child: FutureBuilder(
              //   future:
              //       aptRef.getAptByDateEq(salon.id, datef.format(dayCalendar)),
              //   builder: (BuildContext context, AsyncSnapshot snapshot) {
              //     if (snapshot.hasData) {
              //       List<Appointment> appointments = snapshot.data;
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //         child: ListView.builder(
              //             itemCount: appointments.length,
              //             itemBuilder: (BuildContext contenxt, index) {
              //               return buildAppointmentsDay(appointments[index]);
              //             }),
              //       );
              //     } else
              //       return Center(child: Text('No Appointsments'));
              //   },
              // ))
            ],
          ),
        ),
      ),
    );
  }

  // Container buildAppointmentsDay(Appointment apt) {
  //   return Container(
  //     width: 389,
  //     height: 176,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text('9 AM'),
  //         Row(
  //           children: [
  //             Expanded(
  //               child: Container(
  //                 height: 96,
  //                 child: Align(
  //                   child: VerticalDivider(
  //                     width: 6,
  //                     color: Colors.grey,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Stack(
  //               children: <Widget>[
  //                 Container(
  //                   width: 332,
  //                   height: 96,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.only(
  //                       topLeft: Radius.circular(0),
  //                       topRight: Radius.circular(12),
  //                       bottomLeft: Radius.circular(0),
  //                       bottomRight: Radius.circular(12),
  //                     ),
  //                     boxShadow: [
  //                       BoxShadow(
  //                           color: Color.fromRGBO(244, 64, 64, 1),
  //                           offset: Offset(-4, 0),
  //                           blurRadius: 0.10000000149011612)
  //                     ],
  //                     color: Color.fromRGBO(255, 240, 240, 1),
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                     child: Row(
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                           children: [
  //                             Text(apt.id),
  //                             Container(
  //                               height: 25,
  //                               decoration: BoxDecoration(
  //                                 color: Colors.white,
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(5)),
  //                               ),
  //                               padding: EdgeInsets.all(2),
  //                               child: Row(
  //                                 children: [
  //                                   CircleAvatar(),
  //                                   Text('Wassim Ghernaout')
  //                                 ],
  //                               ),
  //                             ),
  //                             Row(
  //                               children: [
  //                                 CircleAvatar(
  //                                   radius: 12,
  //                                   backgroundImage:
  //                                       NetworkImage(apt.agent.image),
  //                                 )
  //                               ],
  //                             )
  //                           ],
  //                         ),
  //                         Expanded(
  //                             child: Container(
  //                           child: Align(
  //                             alignment: Alignment.centerRight,
  //                             child: CircleAvatar(
  //                               radius: 15,
  //                               backgroundColor: Theme.of(context).primaryColor,
  //                               child: Icon(
  //                                 Icons.arrow_right_alt,
  //                                 color: Colors.white,
  //                                 size: 20,
  //                               ),
  //                             ),
  //                           ),
  //                         ))
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //         Text('9 AM'),
  //       ],
  //     ),
  //   );
  // }
}
