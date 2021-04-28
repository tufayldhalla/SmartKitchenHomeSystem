import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sku_app/models/user_history_item.dart';
import 'package:sku_app/widgets/title_app_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:sku_app/views/trends/trends_viewmodel.dart';
import 'package:sku_app/models/user.dart';
import 'package:sku_app/providers.dart';
import 'package:flutter_riverpod/all.dart';

import 'package:sku_app/views/trends/nutrient_button_list.dart';
import 'package:sku_app/services/user_service.dart';

class Trends extends StatefulWidget {
  @override
  _TrendsState createState() => _TrendsState();
}

class _TrendsState extends State<Trends> {
  int macroIdx = 0;
  int pressedIdx = 0;

  final buttonList = [
    "Calories",
    "Protein",
    "Fat", 
    "Carbs", 
    "Sugar",
    "Cholestrol",
    "Sodium",
    "Fiber",
    "Potassium",
    "Vitamin A", 
    "Vitmain C",
    "Calcium",
    "Iron",
    "Saturated",
    "Mono. Fat",
    "Poly. Fat",
    "Trans. Fat",
    ];

    final nutrientList = [
    "Calories",
    "Protein",
    "Fat", 
    "Carbohydrate", 
    "Sugar",
    "Cholesterol",
    "Sodium",
    "Fiber",
    "Potassium",
    "Vitamin_A", 
    "Vitmain_C",
    "Calcium",
    "Iron",
    "Saturated",
    "Monounsaturated",
    "Polyunsaturated",
    "Trans",
    ];

    List<UserHistoryItem> items = [
    UserHistoryItem(
      date: DateTime.now(),
      calories: 0,
      protein: 0,
      carbohydrate: 0,
      fat: 0,
      sugar: 0,
      cholesterol: 0,
      sodium: 0,
      fiber: 0,
      potassium: 0,
      vitamin_a: 0,
      vitamin_c: 0,
      calcium: 0,
      iron:  0,
      saturated: 0,
      monounsaturated: 0,
      polyunsaturated: 0,
      trans: 0,
    )
    ];

  UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    //Fetch user data contanining their goals from server
    currentUser = context.read(userProvider).state;
    if (currentUser == null) {
      return null;
    }
    
    return ViewModelBuilder<TrendsViewModel>.reactive(
      viewModelBuilder: () => TrendsViewModel(context),
      builder: (context, model, child) => Scaffold(
        appBar: TitleAppbar("Trends"),
        body: Column(
          children: [
          Container(
            padding: EdgeInsets.only(top:10),
            child:Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  model.printDate(),
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.5,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: FlatButton(
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      'Select Date',
                      textScaleFactor: 1,
                    ),
                    onPressed: () async {
                      model.selectDate();                      
                    },
                  ),
                ),
              ],
            )
          ),
          FutureBuilder(
          future: fetchUserHistoryData(currentUser.userID, model.selectedDate, "trends"),
          builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                // while data is loading:
                return Container(
                  height:300,
                  child: Center(
                    child: CircularProgressIndicator(),
                  )
                );
              } else {
                items = snapshot.data;
                return Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                height: 300,
                //TODO check if no data in snapshot 
                child: items.length > 0 ? TrendsChart.withSampleData(items, nutrientList[pressedIdx])
                  : Container(
                    child: Text("No data to show for this time period")
                  )
                );
              }
            }
          ),
          Container(
              height: 90,
              padding: EdgeInsets.all(3),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: buttonList.map((item) {
                      var index = buttonList.indexOf(item);
                      return Container(
                        padding: EdgeInsets.all(3),
                        height: 75,
                        child: RaisedButton(
                          color: pressedIdx == index ? Theme.of(context).canvasColor : Theme.of(context).cardColor,
                          child: new Text(item),
                          shape: CircleBorder(),
                          onPressed: () {
                            if (pressedIdx != index) {
                              setState(() {
                                pressedIdx = index;
                              });

                              print("clicked " + nutrientList[pressedIdx]);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TrendsChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  TrendsChart(this.seriesList, {this.animate});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory TrendsChart.withSampleData(items, String nutrientSelected) {
    return new TrendsChart(
      _createSampleData(items, nutrientSelected),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesNutrient, DateTime>> _createSampleData(items, nutrientSelected) {
    
    // final data = items.map((item) => {
    //   item = item.toJSONEncodable(),
    //   new TimeSeriesNutrient(item["date"], item[nutrientSelected.toLowerCase()])
    // }).toList();
    List<TimeSeriesNutrient> data = [];
    var count = 0; 

    items.forEach((item) {
      item = item.toJSONEncodable();
      data.insert(count, new TimeSeriesNutrient(item["date"], item[nutrientSelected.toLowerCase()]) as TimeSeriesNutrient) ;
      count++;
    });

    return [
      new charts.Series<TimeSeriesNutrient, DateTime>(
        id: 'Nutrient',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesNutrient nut, _) => nut.time,
        measureFn: (TimeSeriesNutrient nut, _) => nut.nutrient,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesNutrient {
  final DateTime time;
  final double nutrient;

  TimeSeriesNutrient(this.time, this.nutrient);
}