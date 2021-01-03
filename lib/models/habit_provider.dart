import 'package:flutter/material.dart';
import 'package:tinyhabits/models/goal.dart';
import 'package:tinyhabits/services/firebase/database.dart';

class HabitProvider extends ChangeNotifier {
  List<Habit> _completed = [];
  List<Habit> _pending = [];
  List<Habit> _deleted = [];

  void addToComplete(Habit habit) async {
    Document<Habit> docRef = Document<Habit>(path: 'habits/${habit.id}');
    _pending.remove(habit);
    habit.dateGoals.add(DateGoal(date: DateTime.now(), status: true));
    _completed.add(habit);
    await docRef.upsert(
        ({'dateGoals': habit.dateGoals.map((e) => e.toJson()).toList()}));
    print(_pending);
    print(_completed);

    notifyListeners();
  }

  void removePending(Habit habit) {
    if (_pending.contains(habit)) {
      _deleted.add(habit);
      _pending.remove(habit);
    }
    print('deletion of pending');
    print(_pending);
    notifyListeners();
  }

  void removeComplete(Habit habit) {
    if (_completed.contains(habit)) {
      _deleted.add(habit);
      _completed.remove(habit);
    }
    notifyListeners();
  }

  void setPending(Habit habit) {
    if (!_pending.contains(habit) && !_deleted.contains(habit))
      _pending.add(habit);
    notifyListeners();
  }

  void setCompleted(Habit habit) {
    if (!_completed.contains(habit) && !_deleted.contains(habit))
      _completed.add(habit);
    notifyListeners();
  }

  List<Habit> get pendingList => _pending;
  List<Habit> get completedList => _completed;

  void reset() {
    _pending = [];
    _completed = [];
    _deleted = [];
    notifyListeners();
  }

  // void reset() {
  //   cart.items = [];
  //   List<String> empty = List<String>();
  //   saveList('cart', empty);
  //   notifyListeners();
  // }
  //
  // int itemsNumber() {
  //   return cart.items.length;
  // }
  //
  // int totalPrice() {
  //   return cart.items
  //       .fold(0, (previousValue, element) => previousValue + element.itemPrice);
  // }
  //
  // void removeProduct(id) {
  //   setProducts(cart.items.where((item) => item.food.foodID != id).toList());
  // }
  //
  // void setItemQuantity(id, qty) {
  //   cart.items
  //       .map((item) => item.food.foodID != id ? item.quantity = qty : item);
  //   notifyListeners();
  // }
  //
  // void setProducts(value) {
  //   cart.items = value;
  //   notifyListeners();
  // }
}
