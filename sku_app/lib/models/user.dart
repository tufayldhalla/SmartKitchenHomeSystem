import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class UserModel {
  String userID;
  String email;
  String firstName = "Firstname";
  String lastName = "Lastname";
  String quote =
      "Today I will do what others won’t, so tomorrow I can accomplish what others can’t. —Jerry Rice";
  int remaining;
  String gender = "Prefer Not to Say";
  DateTime dateOfBirth; // Should be DateTime object
  double calorieGoal = 0.0;
  double proteinGoal = 0.0;
  double carbohydrateGoal = 0.0;
  double fatGoal = 0.0;
  String qrCodePath = "";
  String profilePicPath = "";

  UserModel();

  UserModel.init({@required this.userID, @required this.email});

  String get name => "$firstName $lastName";

  UserModel.loadJson(Map<String, dynamic> json) {
    this.userID = json["User_UID"];
    this.firstName = json["First_Name"];
    this.lastName = json["Last_Name"];
    this.email = json["Email"];
    this.gender = json["Gender"];
    final jbd = json['Date_of_Birth'];
    this.dateOfBirth = (DateFormat('EEE, dd MMM yyyy')).parse(jbd);
    this.calorieGoal = json["Calorie_Goal"];
    this.proteinGoal = json["Protein_Goal"];
    this.carbohydrateGoal = json["Carbohydrate_Goal"];
    this.fatGoal = json["Fat_Goal"];
    this.qrCodePath = json["QR_Code"];
    this.profilePicPath = json["Profile_Picture"];
  }

  Map<String, dynamic> toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    m['User_UID'] = userID;
    m['Email'] = email;
    m['First_Name'] = firstName;
    m['Last_Name'] = lastName;
    m['Gender'] = gender;
    m['Date_of_Birth'] = DateFormat('yyyy-MM-dd').format(dateOfBirth);
    m['Calorie_Goal'] = calorieGoal;
    m['Protein_Goal'] = proteinGoal;
    m['Carbohydrate_Goal'] = carbohydrateGoal;
    m['Fat_Goal'] = fatGoal;
    m['QR_Code'] = qrCodePath;
    m['Profile_Picture'] = profilePicPath;
    return m;
  }
}
