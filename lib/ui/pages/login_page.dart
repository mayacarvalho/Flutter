import 'dart:html';

import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Image(image: AssetImage('lib/ui/assets/logo.png')),
            ), // Container
            Text('Login'.toUpperCase()),
            Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.email)
                    ), // InputDecoration
                    keyboardType: TextInputType.emailAddress,
                  ), // TextFormField
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      icon: Icon(Icons.lock)
                    ), // InputDecoration
                    obscureText: True,
                  ), // TextFormField
                  RaiseButton(
                    onPressed: () {},
                    child:Text('Entrar'.toUpperCase()),
                  ), // RaiseButton
                  FlatButton.icon(
                    onPressed:() {},
                    icon: Icon(Icons.person),
                    label: Text('Criar conta')
                  ) // FlatButton.icon
                ],
              ), // Column
            ), // Form
          ], // <Widget>[]
        ), // Column
      ) // SingleChildScrollView
    );
  }
}