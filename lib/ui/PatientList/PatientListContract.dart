import 'dart:collection';
import 'package:phcovid19tracker/data/DropdownValue.dart';
import 'package:phcovid19tracker/data/PatientDetails.dart';

abstract class PatientListContract {
  // for api call
  void onLoadStatsComplete(List<PatientDetails> item);
  void onCompleteDropdownRegion(List<DropdownValue> list);
  void onCompleteDropdownStatus(List<DropdownValue> list);
  void onLoadStatsError(String onError);
}