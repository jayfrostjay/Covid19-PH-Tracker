import 'package:phcovid19tracker/data/CountryStats.dart';
import 'package:phcovid19tracker/data/LatestCountryStats.dart';
import 'package:phcovid19tracker/data/PatientDetails.dart';
import 'package:phcovid19tracker/repository/APIException.dart';
import 'package:phcovid19tracker/repository/AbstractCovidRepository.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:flutter_config/flutter_config.dart';
import 'package:phcovid19tracker/utils/DateUtils.dart';
import 'package:phcovid19tracker/utils/NetworkUtils.dart';

class CovidRepository implements AbstractCovidRepository {

  var API_URL = FlutterConfig.get('API_BASE_URL');
  var HEADER_API_KEY = FlutterConfig.get('API_KEY');
  var HEADER_API_URL = FlutterConfig.get('API_URL'); 

  var API_URL_PHBREAKDOWN = FlutterConfig.get('API_BASE_URL_PHBREAKDOWN');

  static const LATEST_STATS = "latest_stat_by_country.php";
  static const HISTORY_BY_COUNTRY = "cases_by_particular_country.php";
  static const WORLD_STATS = "cases_by_country.php";

  static const PH_PATIENTS_LIST = "cases";

  static Future<http.Response> requestWrapper({String url, Map<String, String> headers}){
    return http.get(
      Uri.encodeFull(url), 
      headers : headers
    );
  }

  @override
  Future<LatestCountryStats> fetchCountryLatestStats(String countryName) async {
    final response = await requestWrapper(
      url: '$API_URL$LATEST_STATS?country=$countryName',
      headers:  {
        "Accept" : "application/json",
        "x-rapidapi-host" : HEADER_API_URL, 
        "x-rapidapi-key" : HEADER_API_KEY
      }
    );
    
    if( NetworkUtils.isResponseSuccess(response) ){
      try {
        var data = json.decode(response.body);
        return new LatestCountryStats.fromMap(data["latest_stat_by_country"][0]);
      }catch(e){
        throw new APIException("Error: [Function:fetchCountryLatestStats] [Error:$e]");
      }
    } else{
      throw new APIException("Error: [Function:fetchCountryLatestStats] [StatusCode:${response.statusCode}] [Error:${response.reasonPhrase}]");
    }
  }

  @override
  Future<Map<String, dynamic>> fetchWorldLatestStats() async {
    final response = await requestWrapper(
      url: '$API_URL$WORLD_STATS',
      headers:  {
        "Accept" : "application/json",
        "x-rapidapi-host" : HEADER_API_URL, 
        "x-rapidapi-key" : HEADER_API_KEY
      }
    );

    if( NetworkUtils.isResponseSuccess(response) ){
      try {
        var data = json.decode(response.body);
        return {
          "date" :  data["statistic_taken_at"],
          "history" : data["countries_stat"]
        };
      }catch(e){
        throw new APIException("Error: [Function:fetchWorldLatestStats] [Error:$e]");
      }
    } else{
      throw new APIException("Error: [Function:fetchWorldLatestStats] [StatusCode:${response.statusCode}] [Error:${response.reasonPhrase}]");
    }
  }

  @override
  Future<List<CountryStats>> fetchCountryHistory(String countryName) async {
    final response = await requestWrapper(
      url: '$API_URL$HISTORY_BY_COUNTRY?country=$countryName',
      headers:  {
        "Accept" : "application/json",
        "x-rapidapi-host" : HEADER_API_URL, 
        "x-rapidapi-key" : HEADER_API_KEY
      }
    );
    if( NetworkUtils.isResponseSuccess(response) ){
      try {
        var data = json.decode(response.body);
        var history = data["stat_by_country"].reversed.toList();
        List<String> dateList = [];
        List<CountryStats> returnData = [];

        history.forEach((item){
          String formattedDate = DateUtils.formatDateTime("yyyy-MM-dd", DateUtils.timestampToDateTime(item["record_date"])); 
          if( !dateList.contains(formattedDate) ){
            dateList.add(formattedDate);
            returnData.add(new CountryStats.fromMap(item));
          }
        });
        return returnData;
      }catch(e){
        throw new APIException("Error: [Function:fetchCountryHistory] [Error:$e]");
      }
    } else{
      throw new APIException("Error: [Function:fetchWorldLatestStats] [StatusCode:${response.statusCode}] [Error:${response.reasonPhrase}]");
    }
  }

  @override
  Future<List<PatientDetails>> fetchPatientsCases() async {
    final response = await requestWrapper(
        url: '$API_URL_PHBREAKDOWN$PH_PATIENTS_LIST',
        headers:  {
        "Accept" : "application/json",
        }
    );

    if( NetworkUtils.isResponseSuccess(response) ){
      try{
        var data = json.decode(response.body);
        List<PatientDetails> list = [...data.map( (item) => PatientDetails.fromMap(item) )];
        return list;
      }catch(e){
        throw new APIException("Error: [Function:fetchPatientsCases] [Error:$e]");
      }
    }else{
      throw new APIException("Error: [Function:fetchPatientsCases] [StatusCode:${response.statusCode}] [Error:${response.reasonPhrase}]");
    }
  }  
}