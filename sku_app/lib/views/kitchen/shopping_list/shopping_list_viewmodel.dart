import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sku_app/models/user.dart';
import 'package:sku_app/services/user_service.dart';
import 'package:sku_app/providers.dart';
import 'package:stacked/stacked.dart';

class ShoppingListViewModel extends BaseViewModel {
  BuildContext context;
  ShoppingListViewModel(this.context);
  List<String> _shoppingList = [];
  List<String> _recommendations = [];

  List<String> get shoppingList {
    return _shoppingList;
  }

  List<String> get recommendations {
    return _recommendations;
  }

  Future<void> populateShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    _shoppingList = prefs.getStringList("shoppingList");

    if (_shoppingList == null) {
      // initialize cached shopping list as empty
      _shoppingList = [];
      await prefs.setStringList("shoppingList", _shoppingList);
      return;
    }

    notifyListeners();
  }

  Future<void> populateRecommendations() async {
    UserModel currentUser = context.read(userProvider).state;

    if (currentUser == null) {
      return null;
    }

    _recommendations = await fetchRecommendations(currentUser.userID, 3, 7);
    if (_recommendations == null) {
      _recommendations = [];
    }

    notifyListeners();
  }

  Future<void> deletePressed(int index) async {
    final prefs = await SharedPreferences.getInstance();
    String item = _shoppingList[index];
    _shoppingList.removeAt(index);
    await prefs.setStringList("shoppingList", _shoppingList);
    _recommendations.add(item);
    notifyListeners();
  }

  Future<void> addPressed(int index) async {
    final prefs = await SharedPreferences.getInstance();
    String item = _recommendations[index];
    _recommendations.removeAt(index);
    _shoppingList.add(item);
    await prefs.setStringList("shoppingList", _shoppingList);
    notifyListeners();
  }
}
