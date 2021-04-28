import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

import 'camera_viewmodel.dart';

class Camera extends StatefulWidget {
  final CameraDescription camera;
  final bool barcodeMode;
  Camera({this.camera, this.barcodeMode = false});
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.high,
      //So there's no pop-up for mic access
      enableAudio: false,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _barcodeMode = widget.barcodeMode;
    var _title = _barcodeMode ? "Barcode" : "Nutrition Label";
    var _alpha = _barcodeMode ? 100 : 0;
    return ViewModelBuilder<CameraViewModel>.reactive(
      viewModelBuilder: () => CameraViewModel(context),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Scan $_title'),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: model.producePressed,
              child: Text(
                "Skip",
                textScaleFactor: 1.25,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return Stack(children: <Widget>[
                CameraPreview(_controller),
                Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 200,
                      width: 250,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(_alpha, 255, 255, 255),
                              width: 3),
                          color: Color.fromARGB(0, 255, 255, 255)),
                    )),
              ]);
            } else {
              // Otherwise, display a loading indicator.
              return Center(child: CircularProgressIndicator());
            }
          },
        ), //CameraPreview(_controller),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () async {
            // Take the Picture in a try / catch block. If anything goes wrong,
            // catch the error.
            try {
              // Ensure that the camera is initialized.
              await _initializeControllerFuture;

              // Construct the path where the image should be saved using the
              // pattern package.
              final path = join(
                // Store the picture in the temp directory.
                // Find the temp directory using the `path_provider` plugin.
                (await getTemporaryDirectory()).path,
                '${DateTime.now()}.png',
              );

              // Attempt to take a picture and log where it's been saved.
              await _controller.takePicture(path);
              if (path == null) {
                print("Image path null.");
                return;
              }

              //Proccess image
              if (_barcodeMode) {
                await model.processBarcodeImage(path);
              } else {
                await model.processNutritionImage(path);
              }
            } catch (e) {
              // If an error occurs, log the error to the console.
              print(e);
            }
          },
        ),
      ),
    );
  }
}
