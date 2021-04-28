import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String errorMsg;
  ErrorPage(this.errorMsg);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Error"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(errorMsg),
      ),
    );
  }
}
