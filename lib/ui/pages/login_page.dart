import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: Image(image: AssetImage('lib/ui/assets/logo.png')),
          ) // Container
        ], // <Widget>[]
      ), // Column
    ); // SingleChildScrollView
  }
}