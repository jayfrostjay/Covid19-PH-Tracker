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

  static const LATEST_STATS = "country_latest_stats/";
  static const HISTORY_BY_COUNTRY = "country_history/";
  static const WORLD_STATS = "world_stats";
  static const PH_PATIENTS_LIST = "ph_patient_list";

  static Future<http.Response> requestWrapper({String url, Map<String, String> headers}){
    return http.get(
      Uri.encodeFull(url), 
      headers : headers
    );
  }

  @override
  Future<LatestCountryStats> fetchCountryLatestStats(String countryName) async {
    final response = await requestWrapper(
      url: '$API_URL$LATEST_STATS$countryName',
    );
    
    if( NetworkUtils.isResponseSuccess(response) ){
      try {
        var data = json.decode(response.body);
        return new LatestCountryStats.fromMap(data);
      }catch(e){
        throw new APIException("Error: [Function:fetchCountryLatestStats] [Error:$e]");
      }
    } else{
      throw new APIException("Error: [Function:fetchCountryLatestStats] [StatusCode:${response.statusCode}] [Error:${response.reasonPhrase}]");
    }
  }

  @override
  Future<List<CountryStats>> fetchWorldLatestStats() async {
    final response = await requestWrapper(
      url: '$API_URL$WORLD_STATS',
    );

    if( NetworkUtils.isResponseSuccess(response) ){
      try {
        var data = json.decode(response.body);
        List<CountryStats> list = [...data.map( (item) => CountryStats.fromMap(item) )];
        return list;
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
      url: '$API_URL$HISTORY_BY_COUNTRY$countryName',
    );
    if( NetworkUtils.isResponseSuccess(response) ){
      try {
        var data = json.decode(response.body);
        var history = data.reversed.toList();
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
        url: '$API_URL$PH_PATIENTS_LIST',
    );

    print('$API_URL$PH_PATIENTS_LIST');

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