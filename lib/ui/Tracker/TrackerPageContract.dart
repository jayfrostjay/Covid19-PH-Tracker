import 'package:flutter/material.dart';
import 'package:phcovid19tracker/data/LatestCountryStats.dart';

abstract class TrackerPageContract {
  // for api call
  void onLoadStatsComplete(LatestCountryStats item);
  void onLoadStatsError(String onError);
}