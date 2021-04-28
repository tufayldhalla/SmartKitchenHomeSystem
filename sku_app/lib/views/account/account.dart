// Tutorial: https://www.youtube.com/watch?v=WjmQYqRW4zI
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sku_app/views/account/account_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:sku_app/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/all.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AccountViewModel>.reactive(
        // disposeViewModel: false,
        // initialiseSpecialViewModelsOnce: true,
        viewModelBuilder: () => AccountViewModel(context),
        // onModelReady: (model) {
        //   // model.fetchUserProfile();
        // },
        builder: (context, model, child) => SafeArea(
        child:Scaffold(
          appBar: AppBar(
            elevation: 0,
          ),
          body: Consumer(
              builder: (context, watch, child) {
                final currentUser = watch(userProvider).state;
                return Form(
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                    children: [
                      Text(
                        "Profile",
                        textScaleFactor: 2.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 40),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage(
                                  "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png"),
                            ),
                            // Positioned(
                            //   bottom: 0,
                            //   right: 0,
                            //   child: Container(
                            //     height: 40,
                            //     width: 40,
                            //     decoration: BoxDecoration(
                            //         border: Border.all(
                            //           width: 2,
                            //           color:
                            //               Theme.of(context).scaffoldBackgroundColor,
                            //         ),
                            //         shape: BoxShape.circle,
                            //         color: Theme.of(context).primaryColor),
                            //     child: IconButton(
                            //       iconSize: 20,
                            //       icon: Icon(Icons.edit),
                            //       color: Colors.white,
                            //       onPressed: () {
                            //         print("EDIT");
                            //       },
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Text(
                        "Personal Information",
                        textScaleFactor: 1.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Date of Birth: ",
                              textScaleFactor: 1.2,
                            ),
                            Row(
                              children: [
                                Text(
                                  formatter.format(model.birthday),
                                  textScaleFactor: 1.2,
                                ),
                                SizedBox(width: 20),
                                SizedBox(
                                  width: 40.0,
                                  height: 40.0,
                                  child: FloatingActionButton(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    elevation: 0,
                                    child: new Icon(
                                      Icons.date_range,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      await model.selectTimePicker();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 15),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Gender: ",
                              textScaleFactor: 1.2,
                            ),
                            DropdownButton<String>(
                              value: model.gender,
                              //isExpanded: true,
                              underline: Container(
                                height: 1.5,
                                color: Colors.grey,
                              ),
                              onChanged: (String newValue) {
                                model.setGender(newValue);
                              },
                              items: <String>['Male', 'Female', 'Prefer Not to Say']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Daily Goals",
                        textScaleFactor: 1.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          controller: model.calorieController,
                          decoration: InputDecoration(
                            hintText: currentUser.calorieGoal != null ? currentUser.calorieGoal.toString() : "",
                            labelText: "Calorie Goal",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          controller: model.proteinController,
                          decoration: InputDecoration(
                            hintText: currentUser.proteinGoal != null ? currentUser.proteinGoal.toString() : "",
                            labelText: "Protein Goal (g)",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          controller: model.carbsController,
                          decoration: InputDecoration(
                            hintText: currentUser.carbohydrateGoal != null ? currentUser.carbohydrateGoal.toString() : "",
                            labelText: "Carbohydrate Goal (g)",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          controller: model.fatController,
                          decoration: InputDecoration(
                            hintText: currentUser.fatGoal != null ? currentUser.fatGoal.toString() : "",
                            labelText: "Fat Goal (g)",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FlatButton(
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text('Save'),
                              onPressed: () {
                                context.read(userProvider).state.calorieGoal = double.parse(model.calorieController.text);
                                context.read(userProvider).state.proteinGoal = double.parse(model.proteinController.text);
                                context.read(userProvider).state.carbohydrateGoal = double.parse(model.carbsController.text);
                                context.read(userProvider).state.fatGoal = double.parse(model.fatController.text);
                                context.read(userProvider).state.gender = model.gender;
                                context.read(userProvider).state.dateOfBirth = model.birthday;
                                context.read(userProvider).state.gender = model.gender;

                                model.finishSignUp(context.read(userProvider).state);
                              },
                            ),
                            Center(
                              child: TextButton(
                                child: Text(
                                  "Log out",
                                  style: TextStyle(color: Color.fromRGBO(255, 0, 0, 1)),
                                ),
                                onPressed: () async {
                                  await model.signOut();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
              ),
            ),
          );
              },
          ),
        ),
      ),
    );
  }
}
