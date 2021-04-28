import 'package:flutter/material.dart';
import 'package:sku_app/services/user_service.dart';
import 'package:sku_app/views/login/login_viewmodel.dart';
import 'package:stacked/stacked.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(context),
      // onModelReady: (model) async{

      //   String userEmail = await getString("email");
      //   String userPass = await getString("password");
      //   if(userEmail != null && userPass != null){
      //     model.login(userEmail, userPass);
      //   }
      // },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            TextButton(
                onPressed: model.signupPressed,
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(children: [
                Text(
                  "Log In",
                  textScaleFactor: 2.5,
                ),
                TextFormField(
                  onSaved: (input) => _email = input,
                  decoration: InputDecoration(
                    filled: true,
                    //hintText: 'Your email address',
                    labelText: 'Email',
                    errorText: model.emailError ? 'Email not found.' : null,
                  ),
                ),
                TextFormField(
                  onSaved: (input) => _password = input,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Password',
                    errorText:
                        model.passwordError ? 'Password incorrect.' : null,
                  ),
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: FlatButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 100),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      'Log in',
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () async {
                      //Validate user input
                      final formState = _formKey.currentState;
                      formState.save();
                      //Attempt to log in (navigates on success)
                      bool response = await model.login(
                        _email,
                        _password,
                      );

                      response ? model.navigateHome() : print("Login not successful");
                    },
                  ),
                ),
                TextButton(
                  child: Text(
                    "Forgot your password?",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onPressed: model.forgotPasswordPressed,
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
