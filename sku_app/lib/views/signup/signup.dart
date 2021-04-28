import 'package:flutter/material.dart';
import 'package:sku_app/views/signup/signup_viewmodel.dart';
import 'package:stacked/stacked.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String _firstName, _lastName, _email, _password, _secondPassword;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupViewModel>.reactive(
        viewModelBuilder: () => SignupViewModel(context),
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                TextButton(
                    onPressed: model.loginPressed,
                    child: Text(
                      "Log In",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
              ],
            ),
            body: Form(
              key: _formKey,
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Sign Up",
                        textScaleFactor: 2.5,
                      ),
                      TextFormField(
                        validator: (input) {
                          return model.checkName(input);
                        },
                        onSaved: (input) => _firstName = input,
                        decoration: InputDecoration(
                            filled: true, labelText: 'First Name'),
                      ),
                      TextFormField(
                        validator: (input) {
                          return model.checkName(input);
                        },
                        onSaved: (input) => _lastName = input,
                        decoration: InputDecoration(
                            filled: true, labelText: 'Last Name'),
                      ),
                      TextFormField(
                        validator: (input) {
                          return model.checkEmail(input);
                        },
                        onSaved: (input) => _email = input,
                        decoration:
                            InputDecoration(filled: true, labelText: 'Email'),
                      ),
                      TextFormField(
                        validator: (input) {
                          return model.checkPassword(input);
                        },
                        onSaved: (input) => _password = input,
                        decoration: InputDecoration(
                            filled: true, labelText: 'Password'),
                        obscureText: true,
                      ),
                      TextFormField(
                        validator: (input) {
                          final formState = _formKey.currentState;
                          formState.save();
                          return model.checkPasswords(input, _password);
                        },
                        onSaved: (input) => _secondPassword = input,
                        decoration: InputDecoration(
                            filled: true, labelText: 'Re-enter Password'),
                        obscureText: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 100),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            'Sign Up',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () async {
                            //save user input
                            final formState = _formKey.currentState;
                            formState.save();
                            if (formState.validate()) {
                              //Attempt to sign up (navigates on success)
                              await model.signup(
                                  _firstName, _lastName, _email, _password);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
