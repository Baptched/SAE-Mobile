import 'package:flutter/material.dart';
import 'package:sae/UI/connexion.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Connexion(),
    );
  }
}
