import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tinyhabits/helpers/toast.dart';
import 'package:tinyhabits/models/goal.dart';
import 'package:tinyhabits/models/habit_provider.dart';
import 'package:tinyhabits/services/firebase/database.dart';
import 'package:tinyhabits/styles/styles.dart';

class HabitStats extends StatefulWidget {
  final DateTime selectedDate;

  const HabitStats({Key key, this.selectedDate}) : super(key: key);
  @override
  _HabitStatsState createState() => _HabitStatsState();
}

class _HabitStatsState extends State<HabitStats> {
  Collection<Habit> habits = Collection<Habit>(path: 'habits');

  var _startToday = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 0, 0, 0, 0, 0);

  var _endToday = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 23, 59, 59, 0, 0);

  @override
  Widget build(BuildContext context) {
    Provider.of<HabitProvider>(context, listen: false).reset();
    var user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: kPrimaryColor)),
        title: Text(
          'That Day\'s habit',
          style: BigBoldHeading.copyWith(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: habits.getDataById('owner', user.uid),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<Habit> habits = snapshot.data;
              if (habits.length > 0) {
                print(habits);
                var startToday = DateTime(
                    widget.selectedDate.year,
                    widget.selectedDate.month,
                    widget.selectedDate.day,
                    0,
                    0,
                    0,
                    0,
                    0);

                var endToday = DateTime(
                    widget.selectedDate.year,
                    widget.selectedDate.month,
                    widget.selectedDate.day,
                    23,
                    59,
                    59,
                    0,
                    0);

                habits.forEach((habit) {
                  var exists = habit.dateGoals.indexWhere((element) =>
                      element.date.isAfter(startToday) &&
                      element.date.isBefore(endToday));
                  print(exists);
                  if (exists >= 0) {
                    Provider.of<HabitProvider>(context).setCompleted(habit);
                  } else
                    Provider.of<HabitProvider>(context).setPending(habit);
                  return habit;
                });

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rewards

                      Provider.of<HabitProvider>(context).completedList.length >
                              0
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Color(0xFFe7e7e7),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text('You\'re doing great! 😃'),
                                    ),
                                    Positioned(
                                      top: 15,
                                      left: 35,
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xffF79122),
                                        radius: 7,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -7,
                                      left: 120,
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xFFC5E3FE),
                                        radius: 10,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 15,
                                      right: 45,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.redAccent,
                                        radius: 5,
                                      ),
                                    ),
                                    Positioned(
                                      top: 2,
                                      right: 10,
                                      child: Icon(
                                        Icons.add,
                                        size: 35,
                                        color: Colors.greenAccent,
                                      ),
                                    ),
                                    Positioned(
                                      top: -5,
                                      right: 150,
                                      child: Icon(
                                        Icons.add,
                                        size: 20,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 2,
                                      left: 2,
                                      child: Icon(
                                        Icons.add,
                                        size: 25,
                                        color: Colors.lightBlue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pending habits',
                            style: SansHeading.copyWith(
                                fontWeight: FontWeight.normal),
                          ),
                          Text(
                            DateFormat('EEE, MMM d, ' 'yyyy')
                                .format(widget.selectedDate),
                            style: SansHeading.copyWith(
                                fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                      Container(
                        height: 300,
                        child: ListView.builder(
                            itemCount: Provider.of<HabitProvider>(
                              context,
                            ).pendingList.length,
                            itemBuilder: (BuildContext context, index) {
                              var habitP = Provider.of<HabitProvider>(
                                context,
                              ).pendingList[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(habitP.color).withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 60,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: InkWell(
                                          onTap: () {
                                            if (widget.selectedDate
                                                    .isAfter(startToday) &&
                                                widget.selectedDate
                                                    .isBefore(_endToday)) {
                                              Provider.of<HabitProvider>(
                                                      context,
                                                      listen: false)
                                                  .addToComplete(habitP);
                                            } else {
                                              toast('Not there yet !');
                                            }
                                          },
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Color(habitP.color),
                                            child: Icon(
                                              Icons.check,
                                              color:
                                                  Colors.white.withOpacity(0.4),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            habitP.name,
                                            style: SansHeading,
                                          ),
                                          Text(habitP.will),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Completed Habits habits',
                        style:
                            SansHeading.copyWith(fontWeight: FontWeight.normal),
                      ),
                      Container(
                        height: 300,
                        child: ListView.builder(
                            itemCount: Provider.of<HabitProvider>(
                              context,
                            ).completedList.length,
                            itemBuilder: (BuildContext context, index) {
                              var habit = Provider.of<HabitProvider>(
                                context,
                              ).completedList[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(habit.color).withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 60,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: CircleAvatar(
                                          backgroundColor: Color(habit.color),
                                          child: SvgPicture.asset(
                                            'assets/images/happy.svg',
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            habit.name,
                                            style: SansHeading,
                                          ),
                                          Text(habit.will),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                );
              } else
                return NoHabit();
            } else
              return Center(child: CircularProgressIndicator());
          },
        ),
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
        children: [
          Expanded(
            child: Image(
              image: AssetImage(
                'assets/images/emptyBucket.png',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [],
                ),
                Text('Create new habit',
                    textAlign: TextAlign.center,
                    style: BigBoldHeading.copyWith(fontSize: 29)),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Your current habits will come here, create \n one by tapping on the plus button!',
                  textAlign: TextAlign.center,
                  style: GreySubtitle.copyWith(fontSize: 16),
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
    );
  }
}
