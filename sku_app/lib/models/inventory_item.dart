import 'package:intl/intl.dart';

class InventoryItemModel {
  int id = 0;
  int barcode = 0;
  String userId = "";
  String name = "";
  double measuredWeight = 0;
  double weight = 0;
  String weightType = "";
  DateTime expirationDate;
  String scanned = "out";
  int count = 0;

  InventoryItemModel();

  InventoryItemModel.init(int code, String uid, double mass, String massType, [String itemName = ""]) {
    barcode = code;
    userId = uid;
    name = itemName;
    weight = mass;
    weightType = massType;
  }

  InventoryItemModel.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    barcode = json['Barcode'];
    userId = json['User_UID'];
    name = json['Name'];
    measuredWeight = json['Measured_Weight'];
    weight = json['Weight'];
    weightType = json['Weight_Type'];
    final expDate = json['Expiration_Date'];
    expirationDate = (DateFormat('EEE, dd MMM yyyy')).parse(expDate);
    scanned = json["Scanned"];
    count = json["Count"];
  }

  Map<String, dynamic> toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    m['ID'] = 0;
    m['Barcode'] = barcode;
    m['User_UID'] = userId;
    m['Name'] = name;
    m['Measured_Weight'] = measuredWeight;
    m['Weight'] = weight;
    m['Weight_Type'] = weightType;
    m['Expiration_Date'] = DateFormat('yyyy-MM-dd').format(expirationDate);
    m['Scanned'] = scanned;
    m['Count'] = count;
    return m;
  }

  @override
  String toString() {
    return '''
      Barcode: $barcode
      User ID: $userId
      Name: $name
      Measured Weight: $measuredWeight
      Weight: $weight $weightType
      Expiration Date: $expirationDate
      Scanned: $scanned
      Count: $count
    ''';
  }

  addInventoryItemData(double mass, String typeWeight, DateTime expDate,
      [String itemName]) {
    // Parse out all values from the text of a nutrition label
    // Assign values
    if (name == "") {
      name = itemName;
    }
    measuredWeight = 0;
    weight = mass;
    weightType = typeWeight;
    expirationDate = expDate;
  }
}

class WeightType {
  static String count = 'count';
  static String grams = 'g';
  static String mls = 'mL';
  static String ounces = 'oz';
  static String cups = 'cup';
}
