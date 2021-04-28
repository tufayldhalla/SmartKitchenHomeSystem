import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:sku_app/views/login/login.dart';
import 'package:sku_app/views/tab_switcher.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:sku_app/models/user.dart';
import 'package:sku_app/services/user_service.dart';
import 'package:sku_app/services/user_auth.dart';

class AccountViewModel extends BaseViewModel {
  BuildContext context;
  UserModel currentUser;
  final UserAuth _userAuth = UserAuth();

  AccountViewModel(this.context);

  DateTime date = DateTime.now();
  //controllers
  final nameController = TextEditingController();
  final calorieController = TextEditingController();
  final proteinController = TextEditingController();
  final carbsController = TextEditingController();
  final fatController = TextEditingController();

  String gender = "Prefer Not to Say";
  DateTime birthday = DateTime.now();

  Future<Null> selectTimePicker() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: new DateTime.now(),
    );

    if (picked != null && picked != date) {
      birthday = picked;
      notifyListeners();
    }
  }

  void setGender(String gen) {
    gender = gen;
    notifyListeners();
  }

  void finishSignUp(UserModel user) {
    addUser(user);

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => TabSwitcher()));
  }

  Future<void> signOut() async {
    await _userAuth.signOut();

    removeObject("email");
    removeObject("password");

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => Login()),
        (Route<dynamic> route) => false); // remove all pages
  }

  // Future<UserModel> fetchUserProfile(){

  // }
}
