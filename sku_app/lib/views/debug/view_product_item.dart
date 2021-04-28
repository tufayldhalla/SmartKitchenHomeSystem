import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:sku_app/models/product_item.dart';
import 'package:sku_app/providers.dart';
import 'package:sku_app/widgets/title_app_bar.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleAppbar("Item Page"),
      body: Center(
        child: Consumer(builder: (context, watch, child) {
          final _barcode = 4746553;
          final _itemProvider = watch(productItemFetchProvider(_barcode));
          return _itemProvider.map(
              data: (item) => ProductItemWidget(item.value),
              loading: (item) => CircularProgressIndicator(),
              error: (item) => Text(item.error.toString()));
        }),
      ),
    );
  }
}

class ProductItemWidget extends StatelessWidget {
  final ProductItemModel item;
  ProductItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Name: ${item.name}"),
        Text("Barcode: ${item.barcode}"),
        Text("Weight: ${item.weight}${item.weightType}"),
        Text("Calories: ${item.calories}"),
        Text("Fat: ${item.fats}g"),
        Text("    Saturated: ${item.saturated}g"),
        Text("    Monounsaturated: ${item.monounsaturated}g"),
        Text("    Polyunsaturated: ${item.polyunsaturated}g"),
        Text("    Trans: ${item.trans}g"),
        Text("Cholesterol: ${item.cholesterol}mg"),
        Text("Sodium: ${item.sodium}mg"),
        Text("Carbohydrate: ${item.carbohydrate}g"),
        Text("    Fiber: ${item.fiber}g"),
        Text("    Sugars: ${item.sugars}g"),
        Text("Protien: ${item.protein}g"),
        Text("Potassium: ${item.potassium}%"),
        Text("VitaminA: ${item.vitaminA}%"),
        Text("VitaminC: ${item.vitaminC}%"),
        Text("Calcium: ${item.calcium}%"),
        Text("Iron: ${item.iron}%")
      ],
    );
  }
}
