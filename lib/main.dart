import 'package:flutter/material.dart';
import 'package:phcovid19tracker/about.dart';
import './tracker.dart';
import './about.dart';
import './graphs.dart';
import './history.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final String APIHeaderRapidKey = "4db84251f5mshe080beb892a0295p11d59djsn4898d6237f6b";
  final String APIHeaderRapidHost = "coronavirus-monitor.p.rapidapi.com";
  final String LocationKeyPH = "Philippines";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CovidTracker(apiKey: APIHeaderRapidKey, apiHost: APIHeaderRapidHost, locationKey: LocationKeyPH),
      routes: <String, WidgetBuilder>{
        "/about" : (BuildContext context) => new AboutPage(title: "About"),
        "/history" : (BuildContext context) => new CovidHistory(apiKey: APIHeaderRapidKey, apiHost: APIHeaderRapidHost, locationKey: LocationKeyPH),
        "/statistics" : (BuildContext context) => new CovidStatistics(apiKey: APIHeaderRapidKey, apiHost: APIHeaderRapidHost, locationKey: LocationKeyPH)
      },
    );
  }
}