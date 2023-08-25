import 'package:flutter/material.dart';
import 'main.dart';
import 'MyHomePage.dart';

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frontend flutter',
      theme: ThemeData(
        
      ),
      home: const MyHomePage( title: ''),
    );
  }
}
