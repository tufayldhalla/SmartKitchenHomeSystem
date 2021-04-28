import 'package:sku_app/views/account/account.dart';
import 'package:sku_app/views/tab_switcher.dart';
import 'package:stacked/stacked.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:sku_app/providers.dart';
import 'package:sku_app/services/user_service.dart';

class QrCodeViewModel extends BaseViewModel {
  String qrUrl; 
  BuildContext context;

  QrCodeViewModel(this.context);

  void createQRCode(text) async {
    var uri = (Uri.parse("https://codzz-qr-cods.p.rapidapi.com/getQrcode"));
    var response = await http.get(uri.replace(queryParameters: <String, String> {
      	"type": "text",
	      "value": text
    }
    ),
    headers: {
      "x-rapidapi-key": "3ab5779369msh82660942f7d4b0dp1d2c7ejsnbde07b99847e",
	    "x-rapidapi-host": "codzz-qr-cods.p.rapidapi.com",
	    "useQueryString": "true"
    });

    final body = json.decode(response.body);
    qrUrl = body["url"];
    
    context.read(userProvider).state.qrCodePath = qrUrl;
    await saveString("qr", qrUrl);
    
    notifyListeners();

  }

  void confirmedCode(String parentName){

    if (parentName == "signup"){
        Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => Account()));
    } else if (parentName == "home"){
          Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => TabSwitcher()));
    }
  }

  void setQRCode(url){
    qrUrl = url; 
    notifyListeners();
  }

}