import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:sku_app/services/user_service.dart';

class TrendsViewModel extends BaseViewModel {
  dynamic context;
  TrendsViewModel(this.context);

  DateTime selectedDate = DateTime.now();

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

    await saveString("trendsDate", selectedDate.toString());
    //populateDataBasedOnDate();
  }

}