import 'package:woozy_search/woozy_search.dart';

class ProductItemModel {
  int barcode = 0;
  String name = "";
  double weight = 0;
  String weightType = WeightType.grams;
  double calories = 0;
  double fats = 0;
  double saturated = 0;
  double polyunsaturated = 0;
  double monounsaturated = 0;
  double trans = 0;
  double cholesterol = 0;
  double sodium = 0;
  double carbohydrate = 0;
  double fiber = 0;
  double protein = 0;
  double sugars = 0;
  double potassium = 0;
  double vitaminA = 0;
  double vitaminC = 0;
  double calcium = 0;
  double iron = 0;

  ProductItemModel();

  ProductItemModel.initWithBarcode(int bar) {
    barcode = bar;
  }

  final categories = [
    "Per",
    "Calories",
    "Fat",
    "Saturated",
    "Polyunsaturated",
    "Monounsaturated",
    "Trans",
    "Cholesterol",
    "Sodium",
    "Carbohydrate",
    "Fibr",
    "Protein",
    "Sugars",
    "Potassium",
    "Vitamin A",
    "Vitamin C",
    "Calcium",
    "Iron",
  ];

  ProductItemModel.fromJson(Map<String, dynamic> json) {
    barcode = json['Barcode'];
    name = json['Name'];
    weight = json['Weight'];
    weightType = json['Weight_Type'];
    calories = json['Calories'];
    fats = json['Fat'];
    saturated = json['Saturated'];
    polyunsaturated = json['Polyunsaturated'];
    monounsaturated = json['Monounsaturated'];
    trans = json['Trans'];
    cholesterol = json['Cholesterol'];
    sodium = json['Sodium'];
    carbohydrate = json['Carbohydrate'];
    fiber = json['Fiber'];
    protein = json['Protein'];
    sugars = json['Sugars'];
    potassium = json['Potassium'];
    vitaminA = json['Vitamin_A'];
    vitaminC = json['Vitamin_C'];
    calcium = json['Calcium'];
    iron = json['Iron'];
  }

  Map<String, dynamic> toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    m['Barcode'] = barcode;
    m['Name'] = name;
    m['Weight'] = weight;
    m['Weight_Type'] = weightType;
    m['Calories'] = calories;
    m['Fat'] = fats;
    m['Saturated'] = saturated;
    m['Polyunsaturated'] = polyunsaturated;
    m['Monounsaturated'] = monounsaturated;
    m['Trans'] = trans;
    m['Cholesterol'] = cholesterol;
    m['Sodium'] = sodium;
    m['Carbohydrate'] = carbohydrate;
    m['Fiber'] = fiber;
    m['Protein'] = protein;
    m['Sugars'] = sugars;
    m['Potassium'] = potassium;
    m['Vitamin_A'] = vitaminA;
    m['Vitamin_C'] = vitaminC;
    m['Calcium'] = calcium;
    m['Iron'] = iron;
    return m;
  }

  @override
  String toString() {
    return '''
      Name: $name
      Barcode: $barcode
      Weight: $weight $weightType
      Calories: $calories
      Fats: $fats
      Saturated: $saturated
      Polyunsaturated: $polyunsaturated
      Monounsaturated: $monounsaturated
      Trans: $trans
      Cholesterol: $cholesterol
      Sodium: $sodium
      Carbohydrate: $carbohydrate
      Fiber: $fiber
      Protein: $protein
      Sugars: $sugars
      Potassium: $potassium
      Vitamin A: $vitaminA
      Vitamin C: $vitaminC
      Calcium: $calcium
      Iron: $iron
    ''';
  }

  addNutritionLabelData(String extractedText) {
    // Parse out all values from the text of a nutrition label
    final nutritionLabelData = parseNutritionLabelData(extractedText);

    // Assign values
    weight = nutritionLabelData[0];
    calories = nutritionLabelData[1];
    fats = nutritionLabelData[2];
    saturated = nutritionLabelData[3];
    polyunsaturated = nutritionLabelData[4];
    monounsaturated = nutritionLabelData[5];
    trans = nutritionLabelData[6];
    cholesterol = nutritionLabelData[7];
    sodium = nutritionLabelData[8];
    carbohydrate = nutritionLabelData[9];
    fiber = nutritionLabelData[10];
    protein = nutritionLabelData[11];
    sugars = nutritionLabelData[12];
    potassium = nutritionLabelData[13];
    vitaminA = nutritionLabelData[14];
    vitaminC = nutritionLabelData[15];
    calcium = nutritionLabelData[16];
    iron = nutritionLabelData[17];
  }

  List<double> parseNutritionLabelData(String rawText) {
    //Clean-up Extracted Text
    final text = rawText
        .replaceAll("/", " ")
        .replaceAll(",", ".")
        .replaceAll(new RegExp(r" {2,}"), " ");

    //To hold parsed value data
    final data = List<double>.filled(categories.length, -1, growable: false);

    //First find exact matches (faster) in text and parse the value
    for (var i = 0; i < categories.length; i++) {
      //Find nutrition item
      var wordIdx = text.indexOf(categories[i]);

      //Find assosiated nutrion value
      if (wordIdx != -1) {
        //Find start of next number
        var startIdx = text.indexOf(RegExp(r'[0-9]'), wordIdx);
        if (startIdx == -1) {
          continue;
        }

        //Find next char that's not number or decimal
        var endIdx = text.indexOf(RegExp(r'[^0-9\.]'), startIdx);
        if (startIdx == -1 || endIdx == -1) {
          continue;
        }

        //If getting serving size get the 2nd num not 1st
        if (i == 0) {
          final letterIdx = text.indexOf(RegExp(r'[a-zA-Z]'), endIdx);
          startIdx = text.indexOf(RegExp(r'[0-9]'), letterIdx);
          endIdx = text.indexOf(RegExp(r'[^0-9\.]'), startIdx);
        }

        //Parse the data value
        data[i] = parseDataValue(text.substring(startIdx, endIdx));

        //print("Exact Match: ${categories[i]}: ${data[i]}");

        //remove from text
        text.replaceRange(wordIdx, endIdx, "");
      }
    }

    //Find remaining matches with typos via fuzzy search (slower)
    final woozy = Woozy();
    final dataRows = text.split("\n");
    woozy.addEntries(dataRows);

    for (var i = 0; i < categories.length; i++) {
      //If this item was already
      if (data[i] != -1) {
        continue;
      }

      //best match from search is the first
      var match = woozy.search(categories[i]).first;

      //print("Fuzzy Attempt (${match.score}): ${categories[i]} | ${match.text}");

      //score (0 to 1) threshold
      if (match.score <= 0.6) {
        data[i] = 0.0;
      } else {
        //Parse the data value
        data[i] = parseDataValue(match.text);

        //print("Fuzzy Match (${match.score}): ${categories[i]} | ${match.text}");
      }
    }

    // Divide values by serving size to get amounts per gram
    if (data[0] > 0) {
      // Dont divide serving size (data[0])
      for (var i = 1; i < categories.length; i++) {
        if (data[i] > 0) {
          data[i] = data[i] / data[0];
        }
      }
    }

    return data;
  }

  double parseDataValue(String text) {
    //keep only numbers and spaces
    final numStr = text.replaceAll(new RegExp(r'[^0-9\s\.]'), '').trim();

    if (numStr.isEmpty) {
      return 0.0;
    }

    //Get amount not percentage
    final valStr = numStr.split(" ").first;

    return double.parse(valStr);
  }
}

class WeightType {
  static String count = 'count';
  static String grams = 'g';
  static String mls = 'mL';
  static String ounces = 'oz';
  static String cups = 'cup';
}
