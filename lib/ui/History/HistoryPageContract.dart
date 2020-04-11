import 'package:phcovid19tracker/data/CountryStats.dart';

abstract class HistoryPageContract {
  // for api call
  void onLoadStatsComplete(List<CountryStats> item);
  void onLoadStatsError(String onError);
}