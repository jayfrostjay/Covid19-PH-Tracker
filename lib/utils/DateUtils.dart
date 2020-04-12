import 'package:intl/intl.dart';

class DateUtils {
  static DateTime timestampToDateTime(String dateString) {
    var dateStringSplit = dateString.split('.')[0];
    dateStringSplit = dateStringSplit.replaceAll(' ', '');
    dateStringSplit = dateStringSplit.replaceAll('-', '');
    dateStringSplit = dateStringSplit.replaceAll(':', '');
    dateStringSplit = dateStringSplit.substring(0, 8) + 'T' + dateStringSplit.substring(8);
    return DateTime.parse(dateStringSplit);
  }

  static String formatDateTime(String dateFormat, DateTime dateTime){
    if( dateFormat.trim() == "" ){
      dateFormat = "E MMM dd, yyyy - hh:mm:ss a";
    }
    return DateFormat(dateFormat).format(dateTime);
  } 
}