import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sku_app/models/product_item.dart';
import 'package:sku_app/services/item_service.dart';
import 'package:sku_app/views/camera/camera.dart';
import 'package:sku_app/providers.dart';

import '../../models/product_item.dart';

class AddProductItemViewModel extends BaseViewModel {
  ProductItemModel newProductItem;
  bool dataAdded;

  BuildContext context;

  AddProductItemViewModel(this.context);

  void setInitialState(barcode) {
    newProductItem = ProductItemModel.initWithBarcode(barcode);
    dataAdded = false;
  }

  Future<void> uploadNutritionLabel() async {
    final _camera = context.read(cameraProvider).value;
    //Open camera page to get text from a nutrition label
    final extractedText = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                Camera(camera: _camera, barcodeMode: false)));

    print("Extracted Text: $extractedText");

    if (extractedText != null) {
      newProductItem.addNutritionLabelData(extractedText);
      dataAdded = true;
    }
  }

  Future<void> uploadNewItem(name, weight, weightType) async {
    //Dont add without data
    if (!dataAdded) {
      print("Data not added.");
      return;
    }

    //Check name
    if (name.text != "") {
      print(name.text);
      newProductItem.name = name.text;
    }

    newProductItem.weight = double.parse(weight.text);
    newProductItem.weightType = weightType.text;

    // Add new item to DB
    print("Adding new item:\n$newProductItem");
    await addNewProductItem(newProductItem);

    Navigator.pop(context, newProductItem);

    print("Item added.");
  }
}
