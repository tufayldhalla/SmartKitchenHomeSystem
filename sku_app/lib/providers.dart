import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sku_app/models/current_nutrition.dart';
import 'package:sku_app/models/product_item.dart';
import 'package:sku_app/models/user.dart';
import 'package:sku_app/services/item_service.dart';
import 'package:sku_app/services/user_service.dart';

// Item Providers

final productItemFetchProvider = FutureProvider.family
    .autoDispose<ProductItemModel, int>((ref, barcode) async {
  return await fetchProductItem(barcode);
});

final addProductItemProvider =
    FutureProvider.family<void, ProductItemModel>((ref, item) async {
  return addNewProductItem(item);
});

final currentNutritionProvider =
    FutureProvider.autoDispose<CurrentNutrition>((ref) async {
  final user = ref.read(userProvider).state;
  return await fetchCurrentNutrition(user.userID);
});

final userProvider = StateProvider<UserModel>((ref) => null);

final cameraProvider = Provider<CameraState>((ref) => CameraState());

class CameraState {
  CameraDescription value;
}
