import 'package:phcovid19tracker/data/CountryStats.dart';

abstract class WorldStatsPageContract {
  // for api call
  void onLoadStatsComplete(List<CountryStats> item);
  void onLoadStatsError(String onError);
}