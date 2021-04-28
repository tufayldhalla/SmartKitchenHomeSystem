import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sku_app/views/kitchen/inventory/inventory_viewmodel.dart';
import 'package:stacked/stacked.dart';

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  int daysLeft(DateTime expiry) {
    if (expiry == null) {
      return null;
    }
    final now = DateTime.now();
    final difference = expiry.difference(now).inDays;
    return difference;
  }

  Widget build(BuildContext context) {
    return ViewModelBuilder<InventoryViewModel>.reactive(
      viewModelBuilder: () => InventoryViewModel(context),
      onModelReady: (model) {
        if (model.inventoryList.isEmpty) {
          model.populateList();
        }
      },
      builder: (context, model, child) => Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Text('Add Item'),
              onPressed: () async {
                model.addItemPressed();
              },
            ),
          ),
          Column(
            children: model.inventoryList.map((item) {
              return Card(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  children: <Widget>[
                    Container(
                      //width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: RichText(
                        text: new TextSpan(
                          children: <TextSpan>[
                            new TextSpan(
                              text: '${item.name}\n',
                              style: new TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            new TextSpan(
                                text:
                                    'Count: ${item.count}\nTotal quantity left: ${item.weight}${item.weightType}\nExpiration date: ${new DateFormat('yyyy-MM-dd').format(item.expirationDate)},\n${daysLeft(item.expirationDate)} day(s) left',
                                style: new TextStyle(
                                    fontSize: 16, color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
