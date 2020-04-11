import 'package:phcovid19tracker/utils/DateUtils.dart';

class HistoryItem {
  String historyDate;
  int count;

  HistoryItem({this.historyDate, this.count}){
    this.historyDate = DateUtils.formatDateTime("MMM dd, yyyy", DateUtils.timestampToDateTime(this.historyDate));
  }

  HistoryItem.fromMap(Map<String, dynamic> map) : 
    historyDate = map["historyDate"],
    count = map["count"];

  HistoryItem copyWith(historyDate, count){
    return HistoryItem(
      historyDate: historyDate ?? this.historyDate,
      count: count ?? this.count
    );
  }
}