import 'package:phcovid19tracker/utils/DateUtils.dart';

class CountryStats {
  String countryName;
  String confirmed;
  String deaths;
  String recovered;
  String activeCases;
  String newCases;
  String newDeaths;
  String recordDate;
  String formattedRecordDate;

  CountryStats({this.countryName, this.confirmed, this.deaths, this.recovered, this.activeCases, this.newCases, this.newDeaths, this.recordDate});

  CountryStats.fromMap(Map<String, dynamic> map) :
    countryName = map["country_name"],
    confirmed = map["cases"] ?? map["total_cases"],
    deaths = map["deaths"] ?? map["total_deaths"],
    recovered = (map["total_recovered"] != "") ? map["total_recovered"] : "0",
    activeCases = (map["active_cases"] != "") ? map["active_cases"] : "0",
    newCases = (map["new_cases"] != "") ? map["new_cases"] : "0",
    newDeaths = (map["new_deaths"] != "") ? map["new_deaths"] : "0" ,
    recordDate = map["record_date"];

  CountryStats copyWith({countryName, confirmed, deaths, recovered, activeCases, newCases, newDeaths, recordDate}){
    return CountryStats(
      confirmed: confirmed ?? this.confirmed,
      deaths: deaths ?? this.confirmed,
      recovered: recovered ?? this.recovered,
      activeCases: activeCases ?? this.activeCases,
      countryName: countryName ?? this.countryName,
      newDeaths: newDeaths ?? this.newDeaths,
      newCases: newCases ?? this.newCases,
      recordDate: recordDate ?? this.recordDate
    );
  }

  String formatRecordDate() {
    String formattedRecordDate = DateUtils.formatDateTime("E MMM dd", DateUtils.timestampToDateTime(this.recordDate));
    this.formattedRecordDate = formattedRecordDate;
    return this.formattedRecordDate;
  }
}