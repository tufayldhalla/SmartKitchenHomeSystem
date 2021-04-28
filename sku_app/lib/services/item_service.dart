import 'dart:convert';
import 'package:sku_app/models/product_item.dart';
import 'package:sku_app/models/inventory_item.dart';
import 'package:http/http.dart' as http;
import 'package:sku_app/services/service_config.dart';

Future<ProductItemModel> fetchProductItem(int barcode) async {
  final response = await http
      .get("${serverUrl}get_product/$barcode/*")
      .timeout(Duration(seconds: 10));

  if (response.statusCode == 200) {
    print('200');
    final jsonData = jsonDecode(response.body);
    // print('JSON:$jsonData');
    if (jsonData == null) {
      return null;
    } else {
      return ProductItemModel.fromJson(jsonData);
    }
  } else {
    throw Exception('Failed to load item');
  }
}

Future<void> addNewProductItem(ProductItemModel item) async {
  final _json = json.encode(item.toJSONEncodable());
  print(_json);

  final response = await http
      .post(
        "$serverUrl/add_product",
        headers: {"Content-Type": "application/json"},
        body: _json,
      )
      .timeout(Duration(seconds: 10));

  if (response.statusCode == 200) {
    //Item added
    print("Item succesfully added.");
    return;
  } else {
    throw Exception('Failed to add new item');
  }
}

Future<void> addInventoryItem(InventoryItemModel item) async {
  final _json = json.encode(item.toJSONEncodable());
  print(_json);
  print("${serverUrl}add_to_user_inventory");

  final response = await http
      .post(
        "${serverUrl}add_to_user_inventory",
        headers: {"Content-Type": "application/json"},
        body: _json,
      )
      .timeout(Duration(seconds: 20));

  print(response);
  print(response.request);
  print(response.statusCode);
  if (response.statusCode == 200) {
    //Item added
    print("Item succesfully added to inventory.");
    return;
  } else {
    throw Exception('Failed to add item to inventory.');
  }
}
