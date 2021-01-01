import 'package:tinyhabits/models/goal.dart';
import 'package:tinyhabits/models/goal.dart';
import 'package:tinyhabits/models/profile.dart';
import 'package:tinyhabits/services/firebase/database.dart';

class Global {
  static final Map models = {
    Habit: (data) => Habit.fromMap(data),
    // WallFire: (data) => WallFire.fromMap(data),
    // Service: (data) => Service.fromMap(data),
    Profile: (data) => Profile.fromMap(data),
    // Review: (data) => Review.fromMap(data),
    // Appointment: (data) => Appointment.fromMap(data)
  };

  // static final Collection<Salon> salonRef = Collection<Salon>(path: "salon");

  // static final Collection<Appointment> appointRef =
  //     Collection<Appointment>(path: "appointments");
  static final UserData<Profile> profileRef =
      UserData<Profile>(collection: "profiles");
  static final Collection<Habit> habitRef = Collection<Habit>(path: "habits");
  // static final Collection<WallFire> wallfireRef =
  // Collection<WallFire>(path: "wallfire");
}
