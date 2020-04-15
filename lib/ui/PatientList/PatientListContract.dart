import 'dart:collection';
import 'package:phcovid19tracker/data/PatientDetails.dart';

abstract class PatientListContract {
  // for api call
  void onLoadStatsComplete(List<PatientDetails> item);
  void onCompleteDropdownList(List<HashMap<String, dynamic>> dropdownList);
  void onLoadStatsError(String onError);
}