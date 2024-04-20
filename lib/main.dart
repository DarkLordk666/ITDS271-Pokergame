// main.dart

import 'package:flutter/material.dart';
import 'poker_table.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poker App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PokerTable(),
    );
  }
}
