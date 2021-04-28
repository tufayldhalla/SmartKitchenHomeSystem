import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sku_app/providers.dart';
import 'package:sku_app/views/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sku_app/views/tab_switcher.dart';
import 'package:sku_app/services/user_service.dart';
import 'package:sku_app/views/login/login_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    ProviderScope(
      child: MyApp(firstCamera),
    ),
  );
}

class MyApp extends StatefulWidget {
  final camera;
  MyApp(this.camera);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String userEmail;
  String userPass;
  dynamic loginResponse;

  Future<bool> loginState () async {
    userEmail = await getString("email");
    userPass = await getString("password");
    
    
    return LoginViewModel(context).login(userEmail, userPass);
  }

  @override
  void initState() {
    super.initState();
    loginResponse = loginState();
  }

  @override
  Widget build(BuildContext context) {
    context.read(cameraProvider).value = widget.camera;

    Map<int, Color> color = {
      50: Color.fromRGBO(93, 176, 117, .1),
      100: Color.fromRGBO(93, 176, 117, .2),
      200: Color.fromRGBO(93, 176, 117, .3),
      300: Color.fromRGBO(93, 176, 117, .4),
      400: Color.fromRGBO(93, 176, 117, .5),
      500: Color.fromRGBO(93, 176, 117, .6),
      600: Color.fromRGBO(93, 176, 117, .7),
      700: Color.fromRGBO(93, 176, 117, .8),
      800: Color.fromRGBO(93, 176, 117, .9),
      900: Color.fromRGBO(93, 176, 117, 1),
    };

    return FutureBuilder(
          future: loginResponse,
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              // while data is loading:
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'SKU',
                theme: ThemeData(
                  brightness: Brightness.light,
                  /* dark theme settings */
                  primaryColor: Color.fromRGBO(93, 176, 117, 1),
                  primarySwatch:
                      MaterialColor(Color.fromRGBO(93, 176, 117, 1).value, color),
                  cardColor: Colors.grey[350],
                ),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  /* dark theme settings */
                  primaryColor: Color.fromRGBO(93, 176, 117, 1),
                  accentColor: Color.fromRGBO(93, 176, 117, 1),
                ),
                themeMode: ThemeMode.light,
                home: (userEmail == "-" && userPass == "-") || snapshot.data == false ? Login(): TabSwitcher(),
              );
            }
          }
        );

      }
}
