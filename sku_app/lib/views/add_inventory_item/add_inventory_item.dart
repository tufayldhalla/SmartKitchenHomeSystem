import 'package:flutter/material.dart';
import 'package:sku_app/services/item_service.dart';
import 'package:stacked/stacked.dart';
import 'package:sku_app/views/add_inventory_item/add_inventory_item_viewmodel.dart';

class AddInventoryItem extends StatefulWidget {
  final dynamic infoNeeded;
  final bool needsPoll;

  AddInventoryItem(this.infoNeeded, this.needsPoll);

  @override
  _AddInventoryItemState createState() => _AddInventoryItemState();
}

class _AddInventoryItemState extends State<AddInventoryItem> {
  DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddInventoryItemViewModel>.reactive(
      viewModelBuilder: () => AddInventoryItemViewModel(context),
      onModelReady: (model) {
        model.setInitialState(widget.needsPoll, widget.infoNeeded);
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Add to Inventory',
            style: TextStyle(color: Colors.white),
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                borderOnForeground: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
                Card(
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.date_range),
                      TextButton(
                        child: Text(
                          "  Add Exp. Date",
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () async {
                          selectedDate = await showDatePicker(
                            context: context,
                            initialDate: new DateTime.now(),
                            firstDate: new DateTime.now()
                                .subtract(new Duration(days: 30)),
                            lastDate: new DateTime(
                              DateTime.now().year + 5,
                              DateTime.now().month,
                              DateTime.now().day
                            )
                          );
                      },
                    ),
                  ],
                ),
              ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 300),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 100),
                      primary: selectedDate != null
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).disabledColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      'Confirm',
                      textScaleFactor: 1.5,
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      model.addItemToInventory(selectedDate);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
