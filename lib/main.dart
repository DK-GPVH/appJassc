import 'package:flutter/material.dart';
import 'package:jassc/pages/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JASSC ',
      initialRoute: 'login',
      routes: {
        'login': (_) => LoginPage(),
      },
    );
  }
}
