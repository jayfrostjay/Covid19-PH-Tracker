import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:phcovid19tracker/di/DependencyInjectors.dart';
import 'package:phcovid19tracker/ui/Tracker/TrackerPage.dart';
import './graphs.dart';
import './history.dart';
import 'package:flutter_config/flutter_config.dart';
import 'ui/About/AboutView.dart';
import 'package:phcovid19tracker/generated/i18n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  DependencyInjectors();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = {
    "/about" : (BuildContext context) => new AboutPage(),
    "/history" : (BuildContext context) => new CovidHistory(apiKey: FlutterConfig.get('API_KEY'), apiHost: FlutterConfig.get('API_URL'), locationKey: FlutterConfig.get('API_COUNTRY_KEY')),
    "/statistics" : (BuildContext context) => new CovidStatistics(apiKey: FlutterConfig.get('API_KEY'), apiHost: FlutterConfig.get('API_URL'), locationKey: FlutterConfig.get('API_COUNTRY_KEY'))
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData( 
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: TrackerPage(),
      routes: routes,
    );
  }
}