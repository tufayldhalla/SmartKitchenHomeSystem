import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sku_app/models/inventory_item.dart';
import 'package:sku_app/models/user.dart';
import 'package:sku_app/services/user_service.dart';
import 'package:sku_app/views/camera/camera.dart';
import 'package:sku_app/providers.dart';
import 'package:stacked/stacked.dart';

class InventoryViewModel extends BaseViewModel {
  BuildContext context;
  InventoryViewModel(this.context);
  List<InventoryItemModel> _inventoryList = [];

  List<InventoryItemModel> get inventoryList {
    return _inventoryList;
  }

  Future<void> populateList() async {
    //Fetch user inventory from server
    UserModel currentUser = context.read(userProvider).state;
    if (currentUser == null) {
      return null;
    }

    _inventoryList = await fetchUserInventory(currentUser.userID);
    if (_inventoryList == null) {
      _inventoryList = [];
    }

    notifyListeners();
  }

  addItemPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Camera(
          camera: context.read(cameraProvider).value,
          barcodeMode: true,
        ),
      ),
    );
  }
}
