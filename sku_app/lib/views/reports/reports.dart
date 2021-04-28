import 'package:flutter/material.dart';
import 'package:sku_app/widgets/title_app_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:sku_app/views/reports/reports_viewmodel.dart';
import 'package:sku_app/widgets/reports_list.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReportsViewModel>.reactive(
      viewModelBuilder: () => ReportsViewModel(context),
      builder: (context, model, child) => Scaffold(
        appBar: TitleAppbar("Reports"),
        body: Form(
            child: Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
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
                  Flexible(
                    child: ReportsList(model.items),
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
