import 'package:phcovid19tracker/data/CountryStats.dart';
import 'package:phcovid19tracker/data/HistoryItem.dart';
import 'package:phcovid19tracker/data/LatestCountryStats.dart';

abstract class AbstractCovidRepository {
  Future<LatestCountryStats> fetchCountryLatestStats(String countryName);
  Future<Map<String, dynamic>> fetchWorldLatestStats();
  Future<List<HistoryItem>> fetchCountryHistory(String countryName);
}