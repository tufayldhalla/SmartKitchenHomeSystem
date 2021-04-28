import 'package:flutter/material.dart';
import 'package:sku_app/models/product_item.dart';
import 'package:sku_app/services/item_service.dart';
import 'package:sku_app/views/kitchen/kitchen.dart';

class AddProduceItem extends StatefulWidget {
  AddProduceItem();

  @override
  _AddProduceItemState createState() => _AddProduceItemState();
}

class _AddProduceItemState extends State<AddProduceItem> {
  final barcodeController = TextEditingController();
  final nameController = TextEditingController();
  final countController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ProductItemModel newItem;
  bool codeAdded = false;
  bool nameAdded = false;
  bool numAdded = false;

  bool dataAdded() => numAdded && nameAdded && codeAdded;

  @override
  void initState() {
    super.initState();
    newItem = ProductItemModel();
    codeAdded = false;
    nameAdded = false;
    numAdded = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Produce',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      filled: true,
                      labelText: 'Enter Produce Code',
                      hintText: 'ex. 4401'),
                  controller: barcodeController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value.length != 4 || int.tryParse(value) == null) {
                      codeAdded = false;
                      return "Must be a 4-digit number.";
                    }
                    codeAdded = true;
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      filled: true,
                      labelText: 'Enter Name',
                      hintText: 'ex. Banana'),
                  controller: nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value.length <= 0) {
                      nameAdded = false;
                      return "Name cannot be empty.";
                    }
                    nameAdded = true;
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      filled: true,
                      labelText: 'Enter Count',
                      hintText: 'ex. 12'),
                  controller: countController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (int.tryParse(value) == null) {
                      numAdded = false;
                      return "Must be a number.";
                    }
                    numAdded = true;
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 100),
                    primary: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    'Confirm',
                    textScaleFactor: 1.5,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    //Dont add without data
                    if (!dataAdded()) {
                      return;
                    }

                    // Validate returns true if the form is valid, otherwise false.
                    if (_formKey.currentState.validate()) {
                      newItem.barcode = int.parse(barcodeController.text);
                      newItem.name = nameController.text;
                      newItem.weightType = WeightType.count;
                      newItem.weight = double.parse(countController.text);
                      // Add new item to DB
                      print("Adding new item:\n$newItem");
                      await addNewProductItem(newItem);
                      print("Item added");

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Kitchen()));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
