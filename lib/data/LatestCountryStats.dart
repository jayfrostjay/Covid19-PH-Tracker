import 'package:phcovid19tracker/utils/DateUtils.dart';

class LatestCountryStats {
  String confirmed;
  String deaths;
  String recovered;
  String activeCases;
  String recordDate;
  String newDeaths;
  String newCases;
  String formattedRecordDate;

  LatestCountryStats({this.confirmed, this.deaths, this.newDeaths, this.recovered, this.activeCases, this.newCases, this.recordDate}){
    this.formatRecordDate();
  }

  LatestCountryStats.fromMap(Map<String, dynamic> map) :
    confirmed = map["total_cases"],
    deaths = map["total_deaths"],
    recovered = map["total_recovered"],
    activeCases = map["active_cases"],
    recordDate = map["record_date"],
    newDeaths = map["new_deaths"],
    newCases = map["new_cases"];

  String formatRecordDate() {
    String formattedRecordDate = DateUtils.formatDateTime("E MMM dd, yyyy", DateUtils.timestampToDateTime(this.recordDate));
    this.formattedRecordDate = formattedRecordDate;
    return this.formattedRecordDate;
  }

  LatestCountryStats copyWith(confirmed, deaths, newDeaths, recovered, activeCases, newCases, recordDate){
    return LatestCountryStats(
      confirmed: confirmed ?? this.confirmed,
      deaths: deaths ?? this.deaths,
      newDeaths: deaths ?? this.newDeaths,
      recovered: recovered ?? this.recovered,
      activeCases: activeCases ?? this.activeCases,
      newCases: newCases ?? this.newCases,
      recordDate: recordDate ?? this.recordDate
    );
  }
}