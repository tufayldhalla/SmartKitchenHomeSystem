import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class UserHistoryItem {
  DateTime date;
  double calories;
  double protein;
  double carbohydrate;
  double fat;
  double sugar;
  double cholesterol;
  double sodium;
  double fiber; 
  double potassium;
  double vitamin_a;
  double vitamin_c;
  double calcium; 
  double iron; 
  double saturated;
  double monounsaturated;
  double polyunsaturated;
  double trans; 
  bool metGoal = false; 

  UserHistoryItem(
      {
      @required this.date,
      @required this.calories,
      @required this.protein,
      @required this.carbohydrate,
      @required this.fat,
      @required this.sugar,
      @required this.cholesterol,
      @required this.sodium,
      @required this.fiber,
      @required this.potassium,
      @required this.vitamin_a,
      @required this.vitamin_c,
      @required this.calcium, 
      @required this.iron,
      @required this.saturated,
      @required this.monounsaturated,
      @required this.polyunsaturated,
      @required this.trans,
      });

  UserHistoryItem.loadJson(Map<String, dynamic> json) {
    final d = json['Date'];
    this.date = (DateFormat('EEE, dd MMM yyyy')).parse(d);
    this.calories = json["Net_Calories"];
    this.protein = json["Net_Protein"];
    this.carbohydrate = json["Net_Carbohydrate"];
    this.fat = json["Net_Fat"];
    this.sugar = json["Net_Sugars"];
    this.cholesterol = json["Net_Cholesterol"];
    this.sodium = json["Net_Sodium"];
    this.fiber = json["Net_Fiber"];
    this.potassium = json["Net_Potassium"];
    this.vitamin_a = json["Net_Vitamin_A"];
    this.vitamin_c = json["Net_Vitamin_C"];
    this.calcium = json["Net_Calcium"];
    this.iron = json["Net_Iron"];
    this.saturated = json["Net_Saturated"];
    this.monounsaturated = json["Net_Monounsaturated"];
    this.polyunsaturated = json["Net_Polyunsaturated"];
    this.trans = json["Net_Trans"];
  }

  Map<String, dynamic> toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    m['date'] = date;
    m['calories'] = calories;
    m['fat'] = fat;
    m['saturated'] = saturated;
    m['polyunsaturated'] = polyunsaturated;
    m['monounsaturated'] = monounsaturated;
    m['trans'] = trans;
    m['cholesterol'] = cholesterol;
    m['sodium'] = sodium;
    m['carbohydrate'] = carbohydrate;
    m['fiber'] = fiber;
    m['protein'] = protein;
    m['sugars'] = sugar;
    m['potassium'] = potassium;
    m['vitamin_a'] = vitamin_a;
    m['vitamin_c'] = vitamin_c;
    m['calcium'] = calcium;
    m['iron'] = iron;
    return m;
  }
}
