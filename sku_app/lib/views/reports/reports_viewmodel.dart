import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:sku_app/models/user_history_item.dart';
import 'package:sku_app/models/user.dart';
import 'package:sku_app/services/user_service.dart';
import 'package:sku_app/providers.dart';
import 'package:flutter_riverpod/all.dart';

class ReportsViewModel extends BaseViewModel {
  BuildContext context;
  ReportsViewModel(this.context);

  DateTime selectedDate = DateTime.now();
  List<UserHistoryItem> items = [
    UserHistoryItem(
      date: DateTime.now(),
      calories: 0,
      protein: 0,
      carbohydrate: 0,
      fat: 0,
      sugar: 0,
      cholesterol: 0,
      sodium: 0,
      fiber: 0,
      potassium: 0,
      vitamin_a: 0,
      vitamin_c: 0,
      calcium: 0,
      iron: 0,
      saturated: 0,
      monounsaturated: 0,
      polyunsaturated: 0,
      trans: 0,
    )
  ];

  String printDate() {
    return selectedDate == null
        ? "Week of " + DateFormat('yyyy-MM-dd').format(DateTime.now())
        : "Week of " + DateFormat('yyyy-MM-dd').format(selectedDate);
  }

  Future<void> selectDate() async {
    await showDatePicker(
            context: context,
            initialDate: new DateTime.now(),
            firstDate: new DateTime.now().subtract(new Duration(days: 30)),
            lastDate: new DateTime.now().add(new Duration(days: 30)))
        .then((date) {
      selectedDate = date;
      notifyListeners();
    });
    populateDataBasedOnDate();
  }

  Future<void> populateDataBasedOnDate() async {
    //Fetch user data contanining their goals from server
    UserModel currentUser = context.read(userProvider).state;
    if (currentUser == null) {
      return null;
    }

    //Fetch users 7 day history based on date chosen from server
    items =
        await fetchUserHistoryData(currentUser.userID, selectedDate, "reports");
    if (items == null) {
      items.add(UserHistoryItem(
        date: DateTime.now(),
        calories: 0,
        protein: 0,
        carbohydrate: 0,
        fat: 0,
        sugar: 0,
        cholesterol: 0,
        sodium: 0,
        fiber: 0,
        potassium: 0,
        vitamin_a: 0,
        vitamin_c: 0,
        calcium: 0,
        iron: 0,
        saturated: 0,
        monounsaturated: 0,
        polyunsaturated: 0,
        trans: 0,
      ));
    }

    //Logic for determining if user met their goals or not

    // Range that the users consumption should be around
    double plus = 1.1;
    double minus = 0.9;
    // If in range then met goal, else not met goal
    for (var item in items) {
      if (item.calories <= (currentUser.calorieGoal * plus) &&
          item.calories >= (currentUser.calorieGoal * minus) &&
          item.carbohydrate <= (currentUser.carbohydrateGoal * plus) &&
          item.carbohydrate >= (currentUser.carbohydrateGoal * minus) &&
          item.fat <= (currentUser.fatGoal * plus) &&
          item.fat >= (currentUser.fatGoal * minus) &&
          item.protein <= (currentUser.proteinGoal * plus) &&
          item.protein >= (currentUser.proteinGoal * minus)) {
        item.metGoal = true;
      } else {
        item.metGoal = false;
      }
    }

    notifyListeners();
  }
}
