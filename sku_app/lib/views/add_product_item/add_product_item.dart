import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sku_app/services/item_service.dart';
import 'package:stacked/stacked.dart';
import 'package:sku_app/views/add_product_item/add_product_item_viewmodel.dart';

class AddProductItem extends StatefulWidget {
  final int barcode; //accept function passed down

  //define controllers to accept user input.

  AddProductItem(this.barcode);

  @override
  _AddProductItemState createState() => _AddProductItemState();
}

class _AddProductItemState extends State<AddProductItem> {
  final barcodeController = TextEditingController();
  final nameController = TextEditingController();
  final weightController = TextEditingController();
  final weightTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddProductItemViewModel>.reactive(
      viewModelBuilder: () => AddProductItemViewModel(context),
      onModelReady: (model) {
        model.setInitialState(widget.barcode);
      },
      builder: (context, model, child) => Scaffold(
      appBar: AppBar(
        title: Text(
          'Create New Product',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Scrollbar(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Barcode: ${widget.barcode}",
                textScaleFactor: 1.5,
              ),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Enter Product Name',
                ),
                controller: nameController,
              ),
              Column(
                children: [
                  Text(
                    "Upload Nutrition Label",
                  ),
                  Card(
                    borderOnForeground: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.camera_alt_outlined),
                                onPressed: () async {
                                  await model.uploadNutritionLabel();
                                },
                              ),
                              Text("Take Picture")
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.photo_album_outlined),
                                onPressed: () {},
                              ),
                              Text("Upload Picture")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Enter Weight/Count',
                ),
                controller: weightController,
              ),
              TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Enter Weight Type',
                ),
                controller: weightTypeController,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 300),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 100),
                    primary: model.dataAdded
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
                   model.uploadNewItem(nameController, weightController, weightTypeController);
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
