import 'package:phcovid19tracker/data/CountryStats.dart';
import 'package:phcovid19tracker/data/LatestCountryStats.dart';
import 'package:phcovid19tracker/data/PatientDetails.dart';

abstract class AbstractCovidRepository {
  Future<LatestCountryStats> fetchCountryLatestStats(String countryName);
  Future<Map<String, dynamic>> fetchWorldLatestStats();
  Future<List<CountryStats>> fetchCountryHistory(String countryName);
  Future<List<PatientDetails>> fetchPatientsCases();
}