import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sku_app/models/inventory_item.dart';
import 'package:sku_app/models/product_item.dart';
import 'package:sku_app/services/item_service.dart';
import 'package:sku_app/views/add_inventory_item/add_inventory_item.dart';
import 'package:sku_app/views/add_produce_item/add_produce_item.dart';
import 'package:sku_app/views/add_product_item/add_product_item.dart';
import 'package:stacked/stacked.dart';
import 'detail_screen.dart';

class CameraViewModel extends BaseViewModel {
  BuildContext context;
  CameraViewModel(this.context);

  producePressed() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => AddProduceItem()));
  }

  Future<void> processBarcodeImage(String path) async {
    final confirmed = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(path),
      ),
    );

    if (confirmed == null) {
      print("cancelled");
      return;
    }

    final barcode = await extractBarcode(path);

    //Query database for existing item with barcode
    ProductItemModel _productItem = await fetchProductItem(barcode);

    if (_productItem == null) {
      print("Item not found in DB. Creating new item");
      // Navigate to add database item page to create new item in DB
      ProductItemModel productAdded = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => AddProductItem(barcode)));

      print("returned to camera page after product add");
      print(productAdded);
      //we have the product that was added, therefore we dont need to get from db to get information, the product info can be used to add item
      //to inventory.
      InventoryItemModel inventoryAdded = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  AddInventoryItem(productAdded, false)));

      Navigator.pop(context, inventoryAdded);
    } else {
      print("Item found in DB.");
      // Navigate to add inventory page with item from DB
      //In this case, we dont have the product. the addInventoryItem need to get from db
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  AddInventoryItem(barcode, true)));
    }
  }

  Future<void> processNutritionImage(String path) async {
    final extractedText = await extractNutritionLabel(path);
    print("Extracted Text:\n$extractedText");
    Navigator.pop(context, extractedText);
  }

  Future<int> extractBarcode(String path) async {
    final BarcodeDetector barcodeDetector =
        FirebaseVision.instance.barcodeDetector();

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(File(path));

    final List<Barcode> barcodes =
        await barcodeDetector.detectInImage(visionImage);

    var barcode = barcodes.first.displayValue;

    barcode == null
        ? print("Barcode not found.")
        : print("Extracted Barcode: $barcode");

    return int.parse(barcode);
  }

  Future<String> extractNutritionLabel(String path) async {
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(File(path));

    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    return visionText.text;
  }
}
