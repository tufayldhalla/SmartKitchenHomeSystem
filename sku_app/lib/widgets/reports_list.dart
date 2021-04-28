import 'package:flutter/material.dart';
import 'package:sku_app/models/user_history_item.dart';
import 'package:intl/intl.dart';

class ReportsList extends StatelessWidget {
  final List<UserHistoryItem> reportList;

  ReportsList(this.reportList);

  Widget build(BuildContext context) {
    return Column(
      children: reportList.map((item) {
        return Card(
          color: Colors.grey.shade200,
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  text: new TextSpan(
                    children: <TextSpan>[
                      new TextSpan(
                        text:
                            '${DateFormat('yyyy-MM-dd').format(item.date)} - ',
                        style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      new TextSpan(
                        text: item.metGoal ? 'Goal Met\n' : 'Goal Not Met\n',
                        style: new TextStyle(
                          fontSize: 20.0,
                          color: item.metGoal ? Colors.green : Colors.redAccent,
                        ),
                      ),
                      new TextSpan(
                          text:
                              'Calories Consumed - ${item.calories}\n Protein Intake - ${item.protein}g\n Carbohydrate Intake - ${item.carbohydrate}g\n Fat Intake - ${item.fat}g',
                          style:
                              new TextStyle(fontSize: 14, color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
