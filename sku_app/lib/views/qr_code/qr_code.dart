import 'package:flutter/material.dart';
import 'package:sku_app/providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:sku_app/views/qr_code/qr_code_viewmodel.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:stacked/stacked.dart';
import 'package:sku_app/services/user_service.dart';


class QrCode extends StatefulWidget {
  final String userID; 
  final String parentName;
  QrCode(this.userID, this.parentName);

  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  // dynamic qrResponse;

  // void qrState () async {
  //   qrResponse = await getString("qr");
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   qrState();
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getString("qr"),
      builder: (BuildContext context, snapshot) {
        if (snapshot.data == null) {
          // while data is loading:
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ViewModelBuilder<QrCodeViewModel>.reactive(
            disposeViewModel: false,
            initialiseSpecialViewModelsOnce: true,
            viewModelBuilder: () => QrCodeViewModel(context),
            onModelReady: (model) {
              snapshot.data == "-" ? model.createQRCode(widget.userID) : model.setQRCode(snapshot.data);
            },
            builder: (context, model, child) => Container(
            child: Scaffold(
              appBar: AppBar(
                title: Text("QR Code"),
                backgroundColor: Color.fromRGBO(93, 176, 117, 1),
                elevation: 0,
              ),

              body: Consumer(
                builder: (context, watch, child) {
                  return ListView(
                    children: [
                      Center(
                        child: Column(
                            children: [
                              SizedBox(
                              height: 20,
                            ),
                            Stack(
                              children: [
                                Center(
                                  child: Container(
                                    height: 200,
                                    width: 200,
                                    child: Image.asset('assets/frame.png'),
                                  ),
                                ),

                                model.qrUrl != null ? Center(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 10),
                                    height: 190,
                                    width: 190,
                                    child: FadeInImage.assetNetwork(
                                      placeholder: "assets/loading.gif",
                                      placeholderCacheWidth: 30,
                                      placeholderCacheHeight: 30,
                                      image: model.qrUrl),
                                  ),
                                ): Container()
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          "This QR code will be used to sign in with the module so that it can start tracking your nutrition!",
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.2,
                          ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 50),
                            height: 70,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                color: Color.fromRGBO(93, 176, 117, 1)
                            ),
                            child: FlatButton(
                              child: Text("Confirm", style: TextStyle(
                                  color: Colors.white
                              ),),
                              onPressed: (){
                                if (model.qrUrl != null){
                                  context.read(userProvider).state.qrCodePath = model.qrUrl;
                                  model.confirmedCode(widget.parentName);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              )      
            ),
          ),
          );
        }
      }
    );
  }
}