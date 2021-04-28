import 'package:flutter/material.dart';
import 'package:sku_app/services/user_auth.dart';
import 'package:sku_app/views/login/login.dart';
import 'package:sku_app/views/qr_code/qr_code.dart';
import 'package:stacked/stacked.dart';
import 'package:sku_app/providers.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:sku_app/models/user.dart';
import 'package:sku_app/services/user_service.dart';

class SignupViewModel extends BaseViewModel {
  final UserAuth _userAuth = UserAuth();
  BuildContext context;
  SignupViewModel(this.context);

  String checkName(String name) {
    if (name.isNotEmpty) {
      return null;
    }
    return "Name can not be empty";
  }

  String checkEmail(String email) {
    if (RegExp(
            r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return null;
    }
    return "Email entered is not in proper format";
  }

  String checkPassword(String password) {
    if (password.length < 8) {
      return "Password must be greater than 7 characters";
    } else if (!RegExp(r"[a-z]").hasMatch(password)) {
      return "Password must contain 1 lowercase letter";
    } else if (!RegExp(r"[A-Z]").hasMatch(password)) {
      return "Password must contain 1 uppercase letter";
    } else if (!RegExp(r"[0-9]").hasMatch(password)) {
      return "Password must contain 1 numerical digit";
    } else {
      return null;
    }
  }

  String checkPasswords(String password1, String _password2) {
    if (password1 != _password2) {
      return "Password does not match";
    } else {
      return null;
    }
  }

  Future<void> signup(String _firstName, String _lastName, String _email,
      String _password) async {
    //Sign up user
    try {
      final firebaseUser = await _userAuth.signUp(_email, _password);
      if (firebaseUser == null) {
        return;
      }

      //save user information to user object
      UserModel user = UserModel.init(userID: firebaseUser.uid, email: _email);
      user.firstName = _firstName;
      user.lastName = _lastName;
      context.read(userProvider).state = user;

      await saveString("email", _email);
      await saveString("password", _password);
      await saveString("uid", user.userID);

      //Go to accounts page
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => QrCode(user.userID, "signup")));
    } catch (e) {
      print(e.message);
    }
    notifyListeners();
  }

  loginPressed() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => Login()));
  }
}
