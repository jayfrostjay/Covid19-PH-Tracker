import 'package:flutter/material.dart';
import 'package:phcovid19tracker/about.dart';
import './tracker.dart';
import './about.dart';
import './graphs.dart';
import './history.dart';
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterConfig.loadEnvVariables();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final String APIHeaderRapidKey = FlutterConfig.get('API_KEY');
  final String APIHeaderRapidHost = FlutterConfig.get('API_URL');
  final String LocationKeyPH = FlutterConfig.get('API_COUNTRY_KEY');

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