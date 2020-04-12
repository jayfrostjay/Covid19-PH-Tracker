abstract class WorldStatsPageContract {
  // for api call
  void onLoadStatsComplete(Map<String, dynamic> item);
  void onLoadStatsError(String onError);
}