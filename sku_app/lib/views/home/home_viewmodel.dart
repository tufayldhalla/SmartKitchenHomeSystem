import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  BuildContext context;
  HomeViewModel(this.context);
  bool showBar = false;

  void toggleChart() {
    showBar = !showBar;
    notifyListeners();
  }
}
