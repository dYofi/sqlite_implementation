import 'package:flutter/material.dart';
import 'package:sqlite_implementation/constants.dart';
import 'package:sqlite_implementation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}
