import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sku_app/models/current_nutrition.dart';
import 'package:sku_app/providers.dart';
import 'package:sku_app/widgets/title_app_bar.dart';
import 'package:sku_app/widgets/profile_header.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:stacked/stacked.dart';
import 'package:sku_app/views/home/home_viewmodel.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(context),
      builder: (context, model, child) => Scaffold(
        appBar: TitleAppbar('Home'),
        body: Consumer(
          builder: (context, watch, child) {
            final user = watch(userProvider).state;
            final currentNutrition = watch(currentNutritionProvider);

            return SingleChildScrollView(
                child: Column(
              children: <Widget>[
                ProfileHeader(size: size),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    user.name,
                    textScaleFactor: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    user.quote,
                    textScaleFactor: 1.25,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Text("Consumed"),
                            currentNutrition.map(
                              data: (item) => Text(
                                  "${item.value.net_calories.round()}",
                                  textScaleFactor: 1.5),
                              loading: (_) => Text('...', textScaleFactor: 1.5),
                              error: (_) => Text('0', textScaleFactor: 1.5),
                            )
                          ],
                        ),
                      ),
                      Container(
                        //Chart Button
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                          icon: (model.showBar
                              ? Icon(Icons.pie_chart, color: Colors.white)
                              : Transform.rotate(
                                  angle: 90 * pi / 180,
                                  child: Icon(Icons.bar_chart,
                                      color: Colors.white),
                                )),
                          onPressed: model.toggleChart,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Text("Remaining"),
                            currentNutrition.map(
                              data: (item) => Text(
                                  "${(user.calorieGoal - item.value.net_calories.round()).round()}",
                                  textScaleFactor: 1.5),
                              loading: (_) => Text('...', textScaleFactor: 1.5),
                              error: (_) => Text("${user.calorieGoal}",
                                  textScaleFactor: 1.5),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                currentNutrition.map(
                  data: (item) => model.showBar
                      ? NutritionChart.withUserData(item.value)
                      : MacrosChart.withUserData(item.value),
                  loading: (_) => Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: CircularProgressIndicator()),
                  error: (item) => Text(item.error.toString()),
                ),
              ],
            ));
          },
        ),
      ),
    );
  }
}

class NutritionChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  NutritionChart(this.seriesList, {this.animate});

  /// Creates a [BarChart] with user data
  factory NutritionChart.withUserData(CurrentNutrition nutritionData) {
    final nData = [
      ChartData("Carbs", nutritionData.net_carbohydrate.round()),
      ChartData("Fat", nutritionData.net_fats.round()),
      ChartData("Protein", nutritionData.net_protein.round()),
      ChartData("Fiber", nutritionData.net_fiber.round()),
      ChartData("Sugars", nutritionData.net_sugars.round()),
      ChartData("Sodium", nutritionData.net_sodium.round()),
      ChartData("Saturated", nutritionData.net_saturated.round()),
      ChartData("Trans", nutritionData.net_trans.round()),
      ChartData("Cholesterol", nutritionData.net_cholesterol.round()),
      ChartData("Iron", nutritionData.net_iron.round()),
      ChartData("Calcium", nutritionData.net_calcium.round()),
      ChartData("Potasium", nutritionData.net_potassium.round()),
      ChartData("Vitamin A", nutritionData.net_vitaminA.round()),
      ChartData("Vitamin C", nutritionData.net_vitaminC.round()),
    ];

    final chartData = [
      new charts.Series<ChartData, String>(
        id: 'Nutrients',
        domainFn: (ChartData nutr, _) => nutr.name,
        measureFn: (ChartData nutr, _) => nutr.value,
        labelAccessorFn: (ChartData nutr, _) => '${nutr.name}: ${nutr.value}g',
        data: nData,
      )
    ];

    return new NutritionChart(
      chartData,
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: charts.BarChart(
          seriesList,
          animate: false,
          vertical: false,
          barRendererDecorator: new charts.BarLabelDecorator<String>(),
          domainAxis: new charts.OrdinalAxisSpec(
              renderSpec: new charts.NoneRenderSpec()),
          primaryMeasureAxis: new charts.NumericAxisSpec(
              renderSpec: new charts.NoneRenderSpec()),
          // behaviors: [
          //   new charts.DatumLegend(
          //     position: charts.BehaviorPosition.bottom,
          //     //insideJustification: charts.InsideJustification.
          //     outsideJustification: charts.OutsideJustification.middleDrawArea,
          //   )
          // ],
        ));
  }
}

class MacrosChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  MacrosChart(this.seriesList, {this.animate});

  /// Creates a [PieChart] with sample data and no transition.
  factory MacrosChart.withSampleData() {
    return new MacrosChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  factory MacrosChart.withUserData(CurrentNutrition nutritionData) {
    final bool notEmpty = (nutritionData.net_carbohydrate +
            nutritionData.net_fats +
            nutritionData.net_protein >
        0);
    final kPercent = notEmpty
        ? 100 /
            (nutritionData.net_carbohydrate +
                nutritionData.net_fats +
                nutritionData.net_protein)
        : 100;
    final pCarb = (nutritionData.net_carbohydrate * kPercent);
    final pFat = (nutritionData.net_fats * kPercent);
    final pProtien = (nutritionData.net_protein * kPercent);
    final pNone = (1 * kPercent);

    final nData = notEmpty
        ? [
            ChartData("Protein", pProtien.round()),
            ChartData("Fat", pFat.round()),
            ChartData("Carbs", pCarb.round()),
          ]
        : [
            ChartData("Protein", pProtien.round()),
            ChartData("Fat", pFat.round()),
            ChartData("Carbs", pCarb.round()),
            ChartData("None", pNone.round()),
          ];

    final chartData = [
      new charts.Series<ChartData, String>(
        id: 'Macros',
        domainFn: (ChartData macros, _) => macros.name,
        measureFn: (ChartData macros, _) => macros.value,
        labelAccessorFn: (ChartData macros, _) => '${macros.value}%',
        data: nData,
      )
    ];

    return new MacrosChart(
      chartData,
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: charts.PieChart(seriesList,
            animate: true,
            behaviors: [
              new charts.DatumLegend(
                position: charts.BehaviorPosition.bottom,
                //insideJustification: charts.InsideJustification.
                outsideJustification:
                    charts.OutsideJustification.middleDrawArea,
              )
            ],
            defaultRenderer: new charts.ArcRendererConfig(
                arcRendererDecorators: [
                  new charts.ArcLabelDecorator(
                      labelPosition: charts.ArcLabelPosition.auto)
                ])));
  }

  static List<charts.Series<ChartData, String>> _createSampleData() {
    final data = [
      new ChartData("Fat", 100),
      new ChartData("Carbs", 75),
      new ChartData("Protein", 25)
    ];

    return [
      new charts.Series<ChartData, String>(
        id: 'Macros',
        domainFn: (ChartData macros, _) => macros.name,
        measureFn: (ChartData macros, _) => macros.value,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        areaColorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        data: data,
      )
    ];
  }
}

class ChartData {
  final String name;
  final int value;

  ChartData(this.name, this.value);
}
