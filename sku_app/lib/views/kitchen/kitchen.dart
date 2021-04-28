import 'package:flutter/material.dart';
import 'package:sku_app/views/kitchen/inventory/inventory.dart';
import 'package:sku_app/views/kitchen/shopping_list/shopping_list.dart';
import 'package:sku_app/widgets/title_app_bar.dart';

class Kitchen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar("Kitchen"),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: SelectorWidget(),
        ),
      ),
    );
  }
}

class SelectorWidget extends StatefulWidget {
  const SelectorWidget({
    Key key,
  }) : super(key: key);

  @override
  _SelectorWidgetState createState() => _SelectorWidgetState();
}

class _SelectorWidgetState extends State<SelectorWidget> {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
            padding: EdgeInsets.zero,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    child: Text(
                      "Inventory",
                      textScaleFactor: 1.1,
                    ),
                    color: tabIndex == 0
                        ? Theme.of(context).canvasColor
                        : Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    onPressed: () {
                      if (tabIndex != 0) {
                        setState(() {
                          tabIndex = 0;
                        });
                      }
                    },
                  ),
                  FlatButton(
                    color: tabIndex == 1
                        ? Theme.of(context).canvasColor
                        : Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      "Shopping List",
                      textScaleFactor: 1.1,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    onPressed: () {
                      if (tabIndex != 1) {
                        setState(() {
                          tabIndex = 1;
                        });
                      }
                    },
                  ),
                ]),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: tabIndex == 0 ? Inventory() : ShoppingList(),
          ),
        ],
      ),
    );
  }
}
