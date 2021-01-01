import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  DateTime startDate;
  String will;
  String id;
  String name;
  String owner;
  int color;
  List<DateGoal> dateGoals;

  Habit(
      {this.id,
      this.name,
      this.will,
      this.owner,
      this.dateGoals,
      this.startDate,
      this.color});

  Habit.fromMap(Map data) {
    id = data['id'] ?? '';
    will = data['will'] ?? '';
    color = data['color'] ?? 0;
    name = data['name'] ?? '';
    dateGoals = (data['dateGoals'] as List ?? [])
        .map((v) => DateGoal.fromMap(v))
        .toList();

    startDate = (data['startDate'] as Timestamp).toDate() ?? '';

    owner = data['owner'] ?? '';
  }

  Map<String, dynamic> toMap() => {
        "name": name,

        "dateGoals": dateGoals.map((dg) => dg.toJson()).toList(),
        'startDate': Timestamp.fromDate(startDate),
        'color': color,
        "owner": owner,
        "will": will,

        // "__v": v,
      };

  Map toJson() => {
        "name": name,
        "dateGoals": dateGoals,
        'startDate': Timestamp.fromDate(startDate),
        "owner": owner,
        "will": will,
      };
}

class DateGoal {
  bool status;
  DateTime date;

  DateGoal({this.status, this.date});

  DateGoal.fromMap(Map data) {
    status = data['status'] ?? '';
    date = (data['date'] as Timestamp).toDate() ?? '';
  }

  Map toJson() => {"date": Timestamp.fromDate(date), "status": status};
}
