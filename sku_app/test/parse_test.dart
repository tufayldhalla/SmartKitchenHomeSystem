import 'package:flutter_test/flutter_test.dart';
import 'package:sku_app/models/product_item.dart';

void main() {
  test('Nutrition Label Parse Test 1', () {
    var testItem = ProductItemModel.initWithBarcode(62851);
    testItem.name = "excel";
    testItem.weightType = "g";

    final testLabel =
        "Nutrition Facts\nValeur nutritive\nPer 2 pieces (2.8 g)\npour 2 morceaux (2,8 9)\nNGREDIEN\nDEXTRIN, F\nNGREDIE\nSORBITOL\n%Daily Value\n% valeur quotidiennee\nImpor\nTOotsie\nConco\nMade\nAmount\nTeneur\nCalories/ Calories 10\nFat/Lipides 0g\nCarbohydrafe/ Glucides 2 g 1%\nSugars/Sucres 2 g\nProtein/ Protéines 0 g\nwww.\n0 %\nNot a significant source of other\nnutrients\nSource négligeable d'autres éléments\nnutritifs.";

    var sw = Stopwatch()..start();

    testItem.addNutritionLabelData(testLabel);

    print("Nutrition label data parsed. Elapsed: ${sw.elapsedMilliseconds}ms");

    expect(testItem.barcode, 62851);
    expect(testItem.weight, 2.8);
    expect(testItem.weightType, "g");
    expect(testItem.calories, 10 / 2.8);
    expect(testItem.fats, 0);
    expect(testItem.carbohydrate, 2 / 2.8);
    expect(testItem.sugars, 2 / 2.8);
    expect(testItem.protein, 0);
    expect(testItem.saturated, 0);
    expect(testItem.polyunsaturated, 0);
    expect(testItem.monounsaturated, 0);
    expect(testItem.trans, 0);
    expect(testItem.cholesterol, 0);
    expect(testItem.sodium, 0);
    expect(testItem.fiber, 0);
    expect(testItem.potassium, 0);
    expect(testItem.vitaminA, 0);
    expect(testItem.vitaminC, 0);
    expect(testItem.calcium, 0);
    expect(testItem.iron, 0);
  });

  test('Nutrition Label Parse Test 2', () {
    var testItem = ProductItemModel.initWithBarcode(765528854251);
    testItem.name = "chocolate";
    testItem.weightType = "g";

    final testLabel =
        "Valeur nutritive\nNutrition Facts\npour 1 barre (55 g)\nPer 1 bar (55 g)\n%valeur quotidienne*\n% Daily Value*\n27 %\nCalories 300\nLipides / Fat 20 g\nsaturés/Saturated 12g\n+ trans/ Trans 0,1 g\n61 %\nGlucides/ Carbohydrate 29 g\nFibres/ Fibre 1 g\n4 %\n27 %\nSucres/ Sugars 27 g\nProtéines / Protein 4 g\nCholestérol / Cholesterol 10 r\n2 %\nSodium 45 mg\n5\nPotassium 225 mg\n8 %\nCalcium 100 mg\nFer/ Iron 2 mg\n11 %\n*5% ou moins c'est peu, 15% Ou plus c est\nbeaucoup/*5% or less is a little, 15% Or\nmore is a lot\nCHOCOLATS FAVORIS PRODUCTION INC. oLES CHOCOLATS FAVORIS IN\nQUEBEC, QC, CANADA G2C ON2\nCHOCOLATSFAVORIS\nCHOCOLATSFAYORIS.COM\nTOUS DROITS RESERVES\nALL RIGHTS RESERVED";

    var sw = Stopwatch()..start();

    testItem.addNutritionLabelData(testLabel);

    print("Nutrition label data parsed. Elapsed: ${sw.elapsedMilliseconds}ms");

    expect(testItem.barcode, 765528854251);
    expect(testItem.weight, 55);
    expect(testItem.calories, 300 / 55);
    expect(testItem.fats, 20 / 55);
    expect(testItem.carbohydrate, 29 / 55);
    expect(testItem.sugars, 27 / 55);
    expect(testItem.protein, 4 / 55);
    expect(testItem.saturated, 12 / 55);
    expect(testItem.polyunsaturated, 0);
    expect(testItem.monounsaturated, 0);
    expect(testItem.trans, 0.1 / 55);
    expect(testItem.cholesterol, 10 / 55);
    expect(testItem.sodium, 45 / 55);
    expect(testItem.fiber, 1 / 55);
    expect(testItem.potassium, 225 / 55);
    expect(testItem.vitaminA, 0);
    expect(testItem.vitaminC, 0);
    expect(testItem.calcium, 100 / 55);
    expect(testItem.iron, 2 / 55);
  });

  test('Nutrition Label Parse Test 3', () {
    var testItem = ProductItemModel.initWithBarcode(5980037053);
    testItem.name = "kitkat";
    testItem.weightType = "g";

    final testLabel =
        "Nutrition Facts\nAmount/ Teneur\n9% DV 7% VQ Amount / Teneur\n% DV/% V\nValeur nutritive Fat / Lipides 10g\nSaturated/ saturés 6 g\n15 % Carbohydrate / Glucides 24 g 8%\nFibre /Fibres 0 g\n0%\n30 %\nPer 1 bar (36 g)\nTrans/ trans 0.1 g\nSugars/ Sucres 18 g\nPOur 1 barre (s6 g)\nCholesterol / Cholestérol 5 mg 2% Protein / Protéines 2 g\nCalories 190\nSodium 30 mg\nDV=Daily Value\nuvaleur quotidienne\nVitamin A/ Vitamine A\n2 % Vitamin C/ Vitamine C 0%\nCalcium/ Calcium 4 Yo\n Iron/ rer 10 %";

    var sw = Stopwatch()..start();

    testItem.addNutritionLabelData(testLabel);

    print("Nutrition label data parsed. Elapsed: ${sw.elapsedMilliseconds}ms");

    expect(testItem.barcode, 5980037053);
    expect(testItem.weight, 36);
    expect(testItem.calories, 190 / 36);
    expect(testItem.fats, 10 / 36);
    expect(testItem.carbohydrate, 24 / 36);
    expect(testItem.sugars, 18 / 36);
    expect(testItem.protein, 2 / 36);
    expect(testItem.saturated, 6 / 36);
    expect(testItem.polyunsaturated, 0);
    expect(testItem.monounsaturated, 0);
    expect(testItem.trans, 0.1 / 36);
    expect(testItem.cholesterol, 5 / 36);
    expect(testItem.sodium, 30 / 36);
    expect(testItem.fiber, 0);
    expect(testItem.potassium, 0);
    expect(testItem.vitaminA, 2 / 36);
    expect(testItem.vitaminC, 0);
    expect(testItem.calcium, 4 / 36);
    expect(testItem.iron, 10 / 36);
  });

  test('Nutrition Label Parse Test 4', () {
    var testItem = ProductItemModel.initWithBarcode(123123123);
    testItem.name = "froot loops";
    testItem.weightType = "g";

    final testLabel =
        "Nutrition Facts\nAmount/ Teneur\n9% DV 7% VQ Amount / Teneur\n% DV/% V\nValeur nutritive Fat / Lipides 10g\nSaturated/ saturés 6 g\n15 % Carbohydrate / Glucides 24 g 8%\nFibre /Fibres 0 g\n0%\n30 %\nPer 1 bar (36 g)\nTrans/ trans 0.1 g\nSugars/ Sucres 18 g\nPOur 1 barre (s6 g)\nCholesterol / Cholestérol 5 mg 2% Protein / Protéines 2 g\nCalories 190\nSodium 30 mg\nDV=Daily Value\nuvaleur quotidienne\nVitamin A/ Vitamine A\n2 % Vitamin C/ Vitamine C 0%\nCalcium/ Calcium 4 Yo\n Iron/ rer 10 %";

    var sw = Stopwatch()..start();

    testItem.addNutritionLabelData(testLabel);

    print("Nutrition label data parsed. Elapsed: ${sw.elapsedMilliseconds}ms");

    expect(testItem.barcode, 123123123);
    expect(testItem.weight, 27);
    expect(testItem.calories, 110 / 27);
    expect(testItem.fats, 1 / 27);
    expect(testItem.carbohydrate, 24 / 27);
    expect(testItem.sugars, 10 / 27);
    expect(testItem.protein, 1 / 27);
    expect(testItem.saturated, 0.5 / 27);
    expect(testItem.polyunsaturated, 0);
    expect(testItem.monounsaturated, 0);
    expect(testItem.trans, 0);
    expect(testItem.cholesterol, 0);
    expect(testItem.sodium, 100 / 27);
    expect(testItem.fiber, 2 / 27);
    expect(testItem.potassium, 40 / 27);
    expect(testItem.vitaminA, 0);
    expect(testItem.vitaminC, 0);
    expect(testItem.calcium, 0);
    expect(testItem.iron, 25 / 27);
  });

  test('Nutrition Label Parse Test 5', () {
    var testItem = ProductItemModel.initWithBarcode(111222333);
    testItem.name = "cereal";
    testItem.weightType = "g";

    final testLabel =
        "QUOTIDIENNES DE PRODUTS CEREALIERS SOUS FORME DE\nGRAINS ENTIERS.\nINGREDIENTS: DURUM WHOLE GRAIN WHOLE WHEAT SEOLINA\nINGREDIENTS: SEMOULE DE BLE DUR ENTIER A GRAINS ENTIERS\nNutrition Facts\nValeur nutritive\nPer 1/5 package (75 g)\npour 1/5 d'emballage (75 g)\nAmount\nTeneur\n% Daily Value\n% valeur quotidienne\nCalories/ Calories 250\nFat/Lipides 1.5 g\n2 %\nSaturates/ saturés 0.3 g\n+Trans / trans 0 9\n2 %\nCholesterol /Cholestérol 0 mg\nSodium/ Sodium 5 mg\n1 %\nPotassium/ Potassium 350 mg\nCarbohydrate/ Glucides 54 g\nFibre/ Fibres 8 g\n10 %\n18 %\n32 %\nSugars/ Sucres 2 g\nProtein / Protéines 10 g\nVitamin A/Vitamine A\n0\n%\nVitamin C/ Vitamine C\n0%\nCalcium / Calcium\n2 %\nIron/ Fer\n25 %\nThiamine/ Thiamine\n5 %\nRiboflavin / Riboflavine\n4\nNiacin/ Niacine\n40 %\nLOBLAWS INC.\nTORONTO M4T 288, CANADA 2016\nTM/MC LOBLAWS INC.";

    var sw = Stopwatch()..start();

    testItem.addNutritionLabelData(testLabel);

    print("Nutrition label data parsed. Elapsed: ${sw.elapsedMilliseconds}ms");

    expect(testItem.barcode, 111222333);
    expect(testItem.weight, 75);
    expect(testItem.calories, 250 / 75);
    expect(testItem.fats, 1.5 / 75);
    expect(testItem.carbohydrate, 54 / 75);
    expect(testItem.sugars, 2 / 75);
    expect(testItem.protein, 10 / 75);
    expect(testItem.saturated, 0.3 / 75);
    expect(testItem.polyunsaturated, 0 / 75);
    expect(testItem.monounsaturated, 0 / 75);
    expect(testItem.trans, 0);
    expect(testItem.cholesterol, 0);
    expect(testItem.sodium, 5 / 75);
    expect(testItem.fiber, 8 / 75);
    expect(testItem.potassium, 350 / 75);
    expect(testItem.vitaminA, 0 / 75);
    expect(testItem.vitaminC, 0 / 75);
    expect(testItem.calcium, 2 / 75);
    expect(testItem.iron, 25 / 75);
  });

  test('Nutrition Label Parse Test 6', () {
    var testItem = ProductItemModel.initWithBarcode(333222111);
    testItem.name = "Terrys Chocolate Orange";
    final portion = 39;
    testItem.weightType = "g";

    final testLabel =
        "Nutrition Facts\nPer 5 segments (39 g)\nVa\npou\nCalories 200\n%Daily Value\nCal\n15 % Lip\nFat 11 g\nSaturated 7g\n+Trans 0g\n35 %\nGlu\nCarbohydrate 24 g\nFibre 1g\nSugars 23 g\n4\n23 %\nProtein 2g\nCholesterol 10 mg\n2 %\nSodium 40 mg\nPotassium 175 mg\n4\nCalcium 50 mg\n4 %\nIron 1.25 mg\n7 %\nFe\n5% or less is a little, 15% or more is a lot.\ningr edients: Sugur Coco mas, (Ocou bulter, Skim mlk powdn\nMilk fat,Soy lecitin, Naturd orange fovour, Polygyeral poly\nBEST BEFORE:/ MELLEUR AVANT3 COnfons: Mlk, 3oy\nlngredients: Suce\n2021 SE 29 0OUdre, locdoserum e\nExtracted Text: Nutrition Facts\nPer 5 segments (39 g)\nVa\npou\nCalories 200\n%Daily Value\nCal\n15 % Lip\nFat 11 g\nSaturated 7g\n+Trans 0g\n35 %\nGlu\nCarbohydrate 24 g\nFibre 1g\nSugars 23 g\n4\n23 %\nProtein 2g\nCholesterol 10 mg\n2 %\nSodium 40 mg\nPotassium 175 mg\n4\nCalcium 50 mg\n4 %\nIron 1.25 mg\n7 %\nFe\n5% or less is a little, 15% or more is a lot.\ningr edients: Sugur Coco mas, (Ocou bulter, Skim mlk powdn\nMilk fat,Soy lecitin, Naturd orange fovour, Polygyeral poly\nBEST BEFORE:/ MELLEUR AVANT3 COnfons: Mlk, 3oy\nlngredients: Suce\n2021 SE 29 0OUdre, locdoserum e\n";

    var sw = Stopwatch()..start();

    testItem.addNutritionLabelData(testLabel);

    print("Nutrition label data parsed. Elapsed: ${sw.elapsedMilliseconds}ms");

    expect(testItem.barcode, 333222111);
    expect(testItem.weight, portion);
    expect(testItem.calories, 200 / portion);
    expect(testItem.fats, 11 / portion);
    expect(testItem.carbohydrate, 24 / portion);
    expect(testItem.sugars, 23 / portion);
    expect(testItem.protein, 2 / portion);
    expect(testItem.saturated, 7 / portion);
    expect(testItem.polyunsaturated, 0 / portion);
    expect(testItem.monounsaturated, 0 / portion);
    expect(testItem.trans, 0 / portion);
    expect(testItem.cholesterol, 10 / portion);
    expect(testItem.sodium, 40 / portion);
    expect(testItem.fiber, 1 / portion);
    expect(testItem.potassium, 175 / portion);
    expect(testItem.vitaminA, 0 / portion);
    expect(testItem.vitaminC, 0 / portion);
    expect(testItem.calcium, 50 / portion);
    expect(testItem.iron, 1.25 / portion);
  });

test('Nutrition Label Parse Test 7', () {
    var testItem = ProductItemModel.initWithBarcode(444888111);
    testItem.name = "Spinah and cheese pasta sauce";
    final portion = 125;
    testItem.weightType = "ml";

    final testLabel =
        "\nNutrition Facts\nValeur nutritive\nus: Crushed\nwater,\nTd Crushe0\nWater, Spinach,\ntive oil, Asiago\na, Salit,\ntheese\nthese,\nPer 1/2 cup (125 mL)\npour 1/2 tasse (125 mL)\nGarlic\nSCes,\n% Daily Value\n%valeur quotiolenne\nCalories 80\nFat/Lipides 3.5 g\nSaturates/ saturés 1 g\nTrans/ trans 0 g\nentsTomates\n, tomates\noncentrėes), Eau,\nCarbohydrate /Glucides 11g\nFibre / Fibres 3 g\nSugars/ Sucres 6 g\nProtein /Protéines 3 g\nCholesterol/ Cholestérol 5 mg\nSodium 450 mg\n11\n6\n0S, Huile\n2siago\nromage\nmay\nnerbes\nkcide citrique.\nLOBLAWIS ING.\n,CANUADA POtassIum 450 mg\nAT\nIMIMMC\nCalcium 50 mg\nNC.\nIron / Fer 0.75 mg\n*5%% *5 % Or oL less Coi is a , 187o or more s is a C5 h\nAS DEFINED IN CANADIAN REGULATION www. 1\n70u homs c'est peu, 15 % OU p\nUEL QUE LE DEFINIT LA\nHEGLEMENTATION CANADIENNE\nExtracted Text: Nutrition Facts\nValeur nutritive\nus: Crushed\nwater,\nTd Crushe0\nWater, Spinach,\ntive oil, Asiago\na, Salit,\ntheese\nthese,\nPer 1/2 cup (125 mL)\npour 1/2 tasse (125 mL)\nGarlic\nSCes,\n% Daily Value\n%valeur quotiolenne\nCalories 80\nFat/Lipides 3.5 g\nSaturates/ saturés 1 g\nTrans/ trans 0 g\nentsTomates\n, tomates\noncentrėes), Eau,\nCarbohydrate /Glucides 11g\nFibre / Fibres 3 g\nSugars/ Sucres 6 g\nProtein /Protéines 3 g\nCholesterol/ Cholestérol 5 mg\nSodium 450 mg\n11\n6\n0S, Huile\n2siago\nromage\nmay\nnerbes\nkcide citrique.\nLOBLAWIS ING.\n,CANUADA POtassIum 450 mg\nAT\nIMIMMC\nCalcium 50 mg\nNC.\nIron / Fer 0.75 mg\n*5%% *5 % Or oL less Coi is a , 187o or more s is a C5 h\nAS DEFINED IN CANADIAN REGULATION www. 1\n70u homs c'est peu, 15 % OU p\nUEL QUE LE DEFINIT LA\nHEGLEME\n";

    var sw = Stopwatch()..start();

    testItem.addNutritionLabelData(testLabel);

    print("Nutrition label data parsed. Elapsed: ${sw.elapsedMilliseconds}ms");

    expect(testItem.barcode, 444888111);
    expect(testItem.weight, portion);
    expect(testItem.calories, 80 / portion);
    expect(testItem.fats, 3.5 / portion);
    expect(testItem.carbohydrate, 11 / portion);
    expect(testItem.sugars, 6 / portion);
    expect(testItem.protein, 3 / portion);
    expect(testItem.saturated, 1 / portion);
    expect(testItem.polyunsaturated, 0 / portion);
    expect(testItem.monounsaturated, 0 / portion);
    expect(testItem.trans, 0 / portion);
    expect(testItem.cholesterol, 5 / portion);
    expect(testItem.sodium, 450 / portion);
    expect(testItem.fiber, 3 / portion);
    expect(testItem.potassium, 450 / portion);
    expect(testItem.vitaminA, 0 / portion);
    expect(testItem.vitaminC, 0 / portion);
    expect(testItem.calcium, 50 / portion);
    expect(testItem.iron, 0.75 / portion);
  });

  test('Nutrition Label Parse Test 8', () {
    var testItem = ProductItemModel.initWithBarcode(555888111);
    testItem.name = "Dill Pickles";
    final portion = 28;
    testItem.weightType = "g";

    final testLabel =
        "\nNutrition Facts\nValeur nutritive\nINGREDIENTS CEE\nWATER VNEGAR S\n(MUSTARD) AND A\nPer 2 pickles (28 g) pour 2 cornichons (28 980.00ORE\nCALCIUM CHLGADE\nAmount\nTeneur\nCalories / Calories5\n% Daily Value CONIAINS MUST\n% valeur quotidienne MAY CONTAUNE SU\nINGRÉDIENTS AP\nFat/Lipides 0 g\n0 % VINAIGRE SEL EPILES\nETEXTRAT DERE\nO%CALCIUM, POLUIS\nCOLORANT (CIR\nGONIEMT:MOU\nSaturated/ saturés 0g\n+Trans/ trans 0 g\nCholesterol/ Cholestérol 0 mng\nSodium/Sodium 170 mg\nCarbohydrate/ Glucides 1 9\nFibre/Fibres 0 g\n7% PEUT CONTENI S\n19% REFRIGERAIE MTS\n0% REFRCGERERAPES\nSugars/Sucres 0 9\nProtein/ Protéines 0g\nVitamin A/ Vitamine A\nVitamin C/Vitamine C\nCalclum/ Calcium\nIron/Fer\n0%\nLEASE\n2 %\n0 9%\nExtracted Text: Nutrition Facts\nValeur nutritive\nINGREDIENTS CEE\nWATER VNEGAR S\n(MUSTARD) AND A\nPer 2 pickles (28 g) pour 2 cornichons (28 980.00ORE\nCALCIUM CHLGADE\nAmount\nTeneur\nCalories / Calories5\n% Daily Value CONIAINS MUST\n% valeur quotidienne MAY CONTAUNE SU\nINGRÉDIENTS AP\nFat/Lipides 0 g\n0 % VINAIGRE SEL EPILES\nETEXTRAT DERE\nO%CALCIUM, POLUIS\nCOLORANT (CIR\nGONIEMT:MOU\nSaturated/ saturés 0g\n+Trans/ trans 0 g\nCholesterol/ Cholestérol 0 mng\nSodium/Sodium 170 mg\nCarbohydrate/ Glucides 1 9\nFibre/Fibres 0 g\n7% PEUT CONTENI S\n19% REFRIGERAIE MTS\n0% REFRCGERERAPES\nSugars/Sucres 0 9\nProtein/ Protéines 0g\nVitamin A/ Vitamine A\nVitamin C/Vitamine C\nCalclum/ Calcium\nIron/Fer\n0%\nLEASE\n2 \n";

    var sw = Stopwatch()..start();

    testItem.addNutritionLabelData(testLabel);

    print("Nutrition label data parsed. Elapsed: ${sw.elapsedMilliseconds}ms");

    expect(testItem.barcode, 555888111);
    expect(testItem.weight, portion);
    expect(testItem.calories, 5 / portion);
    expect(testItem.fats, 0 / portion);
    expect(testItem.carbohydrate, 1 / portion);
    expect(testItem.sugars, 0 / portion);
    expect(testItem.protein, 0 / portion);
    expect(testItem.saturated, 0 / portion);
    expect(testItem.polyunsaturated, 0 / portion);
    expect(testItem.monounsaturated, 0 / portion);
    expect(testItem.trans, 0 / portion);
    expect(testItem.cholesterol, 0 / portion);
    expect(testItem.sodium, 170 / portion);
    expect(testItem.fiber, 0 / portion);
    expect(testItem.potassium, 0 / portion);
    expect(testItem.vitaminA, 0 / portion);
    expect(testItem.vitaminC, 0 / portion);
    expect(testItem.calcium, 2 / portion);
    expect(testItem.iron, 0 / portion);
  });



  test('Nutrition Label Parse Test 9', () {
    var testItem = ProductItemModel.initWithBarcode(666888111);
    testItem.name = "PC Spaghetti";
    final portion = 75;
    testItem.weightType = "g";

    final testLabel =
        "\nNutrition Facts\nValeur nutritive\nPer 1/5 package (759)\npour 1/5 d'emballage (75 g)\nAmount\n% Daily Valuo\n% valeur quotidienne\neneur\nCalories/ Calories 250\nFat/Lipides 1.5 g\nSaturates/ saturés 0.3 g\n+Trans/ trans 0 g\nCholesterol/ Cholestérol 0 mg\nSodium/ Sodium 5 mg\nPotassium/ Potassium 350 mg\nCarbohydrate/Glucides 54 g\nFibre/ Fibres 8 g\nSugars/ Sucres 29\n2 %\n1 %\n10\n%\n18 %\n32\n%\nProtein / Protéines 10 g\n0%\nVitamin A/VitamineA\nVitamin C/ Vitamine C\n2 %\nCalcium/ calcium\n25 %\nIron/Fer\n15 %\nThiamine/ Thiamine\nRiboflavin /Riboflavine\n4\nExtracted Text: CARDIAQUE LE SPAGTHLTTINT A GRANS ENTICS A J00 %\nMENU BLEUMC PC cONTIENT PEU DL GRAS SATURES\nT DE GRAS TRANS\nGANADA'S F0OD GUIDE RECOMME NDS MAKING AT LEAST\nHALF OF YOUR GRAIN PRODUCTS WIHOLE GRAIN EACH DAY\nLE GUIDE ALIMENTAIRE CANADIEN RECOMMANDE\nDE CONSOMMER AU MOINS LA MOTIE DE VOS PORTIONS\nQUoTIDIENNES DE PRODUITS CEREALIERS SOUS FORME DE\nGRAINS ENTIERS.\nINGREDIENTS: DURUM WHOLE GRAIN WHOLE WHEAT SEOLINA\nINGREDIENTS SEMOULE DE BLE DUN LNTIER A GAAINS ENTIERS\nNutrition Facts\nValeur nutritive\nPer 1/5 package (759)\npour 1/5 d'emballage (75 g)\nAmount\n% Daily Valuo\n% valeur quotidienne\neneur\nCalories/ Calories 250\nFat/Lipides 1.5 g\nSaturates/ saturés 0.3 g\n+Trans/ trans 0 g\nCholesterol/ Cholestérol 0 mg\nSodium/ Sodium 5 mg\nPotassium/ Potassium 350 mg\nCarbohydrate/Glucides 54 g\nFibre/ Fibres 8 g\nSugars/ Sucres 29\n2 %\n1 %\n10\n%\n18 %\n32\n%\nProtein / Protéines 10 g\n0%\nVitamin A/VitamineA\nVitamin C/ Vitamine C\n2 %\nCalcium/ calcium\n25 %\nIron/Fer\n15 %\nThiamine/ Thiamine\nRiboflavin /Riboflavine\n";

    var sw = Stopwatch()..start();

    testItem.addNutritionLabelData(testLabel);

    print("Nutrition label data parsed. Elapsed: ${sw.elapsedMilliseconds}ms");

    expect(testItem.barcode, 666888111);
    expect(testItem.weight, portion);
    expect(testItem.calories, 250 / portion);
    expect(testItem.fats, 1.5 / portion);
    expect(testItem.carbohydrate, 54 / portion);
    expect(testItem.sugars, 2 / portion);
    expect(testItem.protein, 10 / portion);
    expect(testItem.saturated, 0.3 / portion);
    expect(testItem.polyunsaturated, 0 / portion);
    expect(testItem.monounsaturated, 0 / portion);
    expect(testItem.trans, 0 / portion);
    expect(testItem.cholesterol, 0 / portion);
    expect(testItem.sodium, 5 / portion);
    expect(testItem.fiber, 8 / portion);
    expect(testItem.potassium, 350 / portion);
    expect(testItem.vitaminA, 0 / portion);
    expect(testItem.vitaminC, 0 / portion);
    expect(testItem.calcium, 2 / portion);
    expect(testItem.iron, 25 / portion);
  });
}