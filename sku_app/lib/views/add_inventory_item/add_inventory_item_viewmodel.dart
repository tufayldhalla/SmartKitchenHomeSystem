import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sku_app/models/inventory_item.dart';
import 'package:sku_app/models/product_item.dart';
import 'package:sku_app/services/item_service.dart';
import 'package:sku_app/models/user.dart';
import 'package:sku_app/providers.dart';

class AddInventoryItemViewModel extends BaseViewModel {
  InventoryItemModel inventoryItem;
  ProductItemModel newProduct;

  BuildContext context;

  AddInventoryItemViewModel(this.context);

  Future<void> setInitialState(needsPoll, infoNeeded) async {
    UserModel currentUser = context.read(userProvider).state;
    if (currentUser == null) {
      return null;
    }

    if (needsPoll) {
      ProductItemModel newProduct;
      fetchProductItem(infoNeeded).then((value) {
        newProduct = value;
        //Init with barcode, userID, name,
        inventoryItem = InventoryItemModel.init(
            newProduct.barcode, currentUser.userID, newProduct.weight, newProduct.weightType, newProduct.name);
      });
    } else {
      //neededInfo contains the name etc.
      inventoryItem = InventoryItemModel.init(
          infoNeeded.barcode, currentUser.userID, infoNeeded.weight, infoNeeded.weightType, infoNeeded.name);
    }
  }

  Future<void> addItemToInventory(date) async{
    inventoryItem.expirationDate = date;
    inventoryItem.count = 1;

    // Add new item to DB
    print("Adding new item to inventory:\n$inventoryItem");
    await addInventoryItem(inventoryItem);
    print("Item added to inventory.");

    Navigator.pop(context, inventoryItem);
  }
}
