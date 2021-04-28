import 'package:flutter/material.dart';
import 'dart:io';

class DetailScreen extends StatelessWidget {
  final String imagePath;
  DetailScreen(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Confirm"),
            centerTitle: true,
            actions: [
              IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    Navigator.pop(context, true);
                  }),
            ],
          ),
          body: Image.file(
            File(imagePath),
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          )),
    );
  }
}
