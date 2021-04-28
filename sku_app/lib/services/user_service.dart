import 'dart:convert';
import 'package:sku_app/models/inventory_item.dart';
import 'package:sku_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sku_app/models/current_nutrition.dart';
import 'package:sku_app/models/user_history_item.dart';
import 'package:sku_app/services/service_config.dart';

Future<UserModel> fetchUserData(String userID) async {
  final response = await http
      .get("${serverUrl}get_from_users/$userID/*")
      .timeout(Duration(seconds: 10));

  if (response.statusCode == 200) {
    print('200');
    final jsonData = jsonDecode(response.body);
    print('JSON:$jsonData');
    if (jsonData == null) {
      return null;
    } else {
      return UserModel.loadJson(jsonData);
    }
  } else {
    throw Exception('Failed to load user');
  }
}

Future<List<UserHistoryItem>> fetchUserHistoryData(
    String userID, DateTime date, String reason) async {
  List<UserHistoryItem> items = [];
  final DateTime date7 = date.add(Duration(days: 7));
  final String conditionString =
      "User_UID='$userID' AND Date>='$date' AND Date<='$date7'";

  final response = await http
      .get(
          "${serverUrl}get_from_users_history_based_on_condition/$conditionString/*")
      .timeout(Duration(seconds: 20));

  if (response.statusCode == 200) {
    print('200');
    final jsonData = jsonDecode(response.body);
    print('JSON:$jsonData');
    if (jsonData == null) {
      return null;
    } else {
      for (var users_history in jsonData) {
        items.add(UserHistoryItem.loadJson(users_history));
      }
      return items;
    }
  } else {
    throw Exception('Failed to load users history');
  }
}

Future<CurrentNutrition> fetchCurrentNutrition(String userID) async {
  final response = await http
      .get("${serverUrl}get_all_users_history/$userID/*")
      .timeout(Duration(seconds: 20));
  if (response.statusCode == 200) {
    print('200');
    final jsonData = jsonDecode(response.body);
    print('JSON:$jsonData');

    if (jsonData == null) {
      throw Exception("Daily nutrition data not found.");
    } else if (jsonData.length == 0) {
      return new CurrentNutrition();
    } else {
      final cn = CurrentNutrition.fromJson(jsonData[jsonData.length - 1]);
      print(cn);
      return cn;
    }
  } else {
    throw Exception('Failed to load user');
  }
}

Future<void> addUser(UserModel user) async {
  final _json = json.encode(user.toJSONEncodable());
  print(_json);

  final response = await http
      .post(
        "$serverUrl/add_to_users",
        headers: {"Content-Type": "application/json"},
        body: _json,
      )
      .timeout(Duration(seconds: 20));

  if (response.statusCode == 200) {
    //User added
    print("User succesfully added.");
    return;
  } else {
    throw Exception('Failed to add new user');
  }
}

@override
Future<String> getString(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys();
  if (keys.contains(key)) {
    return prefs.getString(key);
  } else {
    return "-";
  }
}

@override
Future<void> saveString(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<List<InventoryItemModel>> fetchUserInventory(String userID) async {
  List<InventoryItemModel> inventoryItems = [];
  final response = await http
      .get("${serverUrl}get_all_user_inventory/$userID/*")
      .timeout(Duration(seconds: 20));

  if (response.statusCode == 200) {
    print('200');
    final jsonData = jsonDecode(response.body);
    print('JSON:$jsonData');
    if (jsonData == null) {
      return null;
    } else {
      for (var inventoryItem in jsonData) {
        inventoryItems.add(InventoryItemModel.fromJson(inventoryItem));
      }
      return inventoryItems;
    }
  } else {
    throw Exception('Failed to fetch user inventory');
  }
}

Future<List<String>> fetchRecommendations(
    String userID, int occurencesThresh, int daysThresh) async {
  Set<String> recommendations = Set();
  final prefs = await SharedPreferences.getInstance();
  List<String> shoppingListString = prefs.getStringList("shoppingList");
  final DateTime expiryThresh = DateTime.now().add(Duration(days: daysThresh));

  // Fetch items from user inventory where expiration date <= expiryThresh
  String conditionString =
      "User_UID='$userID' AND Expiration_Date<='$expiryThresh'";
  final inventoryResponse = await http
      .get(
          "${serverUrl}get_from_user_inventory_based_on_condition/$conditionString/*")
      .timeout(Duration(seconds: 20));

  // Fetch items from user occurences where item occurrence >= occurencesThresh
  conditionString = "User_UID='$userID' AND Occurrences>='$occurencesThresh'";
  final occurResponse = await http
      .get(
          "${serverUrl}get_from_items_occurrences_based_on_condition/$conditionString/*")
      .timeout(Duration(seconds: 20));

  if (inventoryResponse.statusCode == 200 && occurResponse.statusCode == 200) {
    print('200');
    final inventoryJsonData = jsonDecode(inventoryResponse.body);
    final occurJsonData = jsonDecode(occurResponse.body);
    print('JSON:$inventoryJsonData');
    print('JSON:$occurJsonData');
    if (inventoryJsonData == null && occurJsonData == null) {
      return null;
    } else {
      for (var inventoryItem in inventoryJsonData) {
        if (!shoppingListString.contains(inventoryItem["Name"])) {
          recommendations.add(inventoryItem["Name"]);
        }
      }
      for (var occurance in occurJsonData) {
        if (!shoppingListString.contains(occurance["Name"])) {
          recommendations.add(occurance["Name"]);
        }
      }
      return recommendations.toList();
    }
  } else {
    throw Exception('Failed to fetch recommended');
  }
}

@override
Future<void> removeObject(String key) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}
