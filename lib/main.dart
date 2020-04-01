import 'package:flutter/material.dart';
import 'package:phcovid19tracker/about.dart';
import './tracker.dart';
import './about.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CovidTracker(),
      routes: <String, WidgetBuilder>{
        "/about" : (BuildContext context) => new AboutPage("About")
      },
    );
  }
}