class CurrentNutrition {
  double net_calories = 0.0;
  double net_fats = 0.0;
  double net_saturated = 0.0;
  double net_polyunsaturated = 0.0;
  double net_monounsaturated = 0.0;
  double net_trans = 0.0;
  double net_cholesterol = 0.0;
  double net_sodium = 0.0;
  double net_carbohydrate = 0.0;
  double net_fiber = 0.0;
  double net_protein = 0.0;
  double net_sugars = 0.0;
  double net_potassium = 0.0;
  double net_vitaminA = 0.0;
  double net_vitaminC = 0.0;
  double net_calcium = 0.0;
  double net_iron = 0.0;

  CurrentNutrition();

  CurrentNutrition.fromJson(Map<String, dynamic> json) {
    net_calories = json['Net_Calories'];
    net_fats = json['Net_Fat'];
    net_saturated = json['Net_Saturated'];
    net_polyunsaturated = json['Net_Polyunsaturated'];
    net_monounsaturated = json['Net_Monounsaturated'];
    net_trans = json['Net_Trans'];
    net_cholesterol = json['Net_Cholesterol'];
    net_sodium = json['Net_Sodium'];
    net_carbohydrate = json['Net_Carbohydrate'];
    net_fiber = json['Net_Fiber'];
    net_protein = json['Net_Protein'];
    net_sugars = json['Net_Sugars'];
    net_potassium = json['Net_Potassium'];
    net_vitaminA = json['Net_Vitamin_A'];
    net_vitaminC = json['Net_Vitamin_C'];
    net_calcium = json['Net_Calcium'];
    net_iron = json['Net_Iron'];
  }

  @override
  String toString() {
    return '''
      net_calories: $net_calories
      net_carbohydrate: $net_carbohydrate
      net_fats: $net_fats
      net_protein: $net_protein
      net_sugars: $net_sugars
      net_sodium: $net_sodium
      net_trans: $net_trans
      net_saturated: $net_saturated
      net_cholesterol: $net_cholesterol
      net_fiber: $net_fiber
      net_iron: $net_iron
      net_calcium: $net_calcium
      net_potassium: $net_potassium
      net_vitaminA: $net_vitaminA
      net_vitaminC: $net_vitaminC
    ''';
  }
}
