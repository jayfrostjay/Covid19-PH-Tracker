import 'package:phcovid19tracker/utils/DateUtils.dart';

class CountryStats {
  String confirmed;
  String deaths;
  String recovered;
  String activeCases;
  String recordDate;
  String formattedRecordDate;

  CountryStats({this.confirmed, this.deaths, this.recovered, this.activeCases, this.recordDate}){
    this.formatRecordDate();
  }

  CountryStats.fromMap(Map<String, dynamic> map) :
    confirmed = map["confirmed"],
    deaths = map["deaths"],
    recovered = map["recovered"],
    activeCases = map["active_cases"],
    recordDate = map["record_date"];

  void formatRecordDate() {
    String formattedRecordDate = DateUtils.formatDateTime("E MMM dd, yyyy - hh:mm:ss a", DateUtils.timestampToDateTime(this.recordDate));
    this.recordDate = formattedRecordDate;
  }

  CountryStats copyWith({confirmed, deaths, recovered, activeCases, recordDate}){
    return CountryStats(
      confirmed: confirmed ?? this.confirmed,
      deaths: deaths ?? this.confirmed,
      recovered: recovered ?? this.recovered,
      activeCases: activeCases ?? this.activeCases,
      recordDate: recordDate ?? this.recordDate
    );
  }
}