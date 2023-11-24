import 'package:flutter/material.dart';
import 'package:mobile/screens/homepage.dart';

void main() => runApp(ToDoList());

class ToDoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Homepage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          color: Colors.green,
        )
      ),
    );
  }
}
