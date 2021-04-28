import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:sku_app/models/user.dart';
import 'package:sku_app/services/user_auth.dart';
import 'package:sku_app/services/user_service.dart';
import 'package:sku_app/views/login/login.dart';
import 'package:sku_app/views/signup/signup.dart';
import 'package:sku_app/views/tab_switcher.dart';
import 'package:stacked/stacked.dart';
import 'package:sku_app/providers.dart';

class LoginViewModel extends BaseViewModel {
  final UserAuth _userAuth = UserAuth();
  BuildContext context;
  LoginViewModel(this.context);
  UserModel currentUser;

  bool passwordError = false;
  bool emailError = false;

  Future<bool> login(String _email, String _password) async {
    //Authenticte user
    if (_email == "-" || _password == "-") {
      //data was likely not in cache
      return false;
    }

    try {
      final firebaseUser = await _userAuth.signIn(_email, _password);
      if (firebaseUser == null) {
        return false;
      }

      print("fetching ****************************");
      currentUser =
          UserModel.init(userID: firebaseUser.uid, email: firebaseUser.email);

      //Fetch data from server
      currentUser = await fetchUserData(currentUser.userID);
      if (currentUser == null) {
        print("User data not found.");
        return false;
      }

      //Init logged in user
      context.read(userProvider).state = currentUser;

      await saveString("email", currentUser.email);
      await saveString("password", _password);
      await saveString("uid", currentUser.userID);
      await saveString("qr", currentUser.qrCodePath);

      print("log in complete");
      return true;
    } catch (e) {
      if (e.message == UserAuth.passwordError) {
        passwordError = true;
        emailError = false;
      } else if (e.message == UserAuth.emailError) {
        emailError = true;
      }
      notifyListeners();
      return false;
    }
  }

  signupPressed() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Signup()));
  }

  forgotPasswordPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => Login()));
  }

  navigateHome() {
    //Go to main page
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => TabSwitcher()));
  }
}
