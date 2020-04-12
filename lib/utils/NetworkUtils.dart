import 'package:http/http.dart' as http;
import 'dart:convert' show json;

class NetworkUtils {
  
  static const STATUS_CODE_SUCCESS = 200;

  static bool isResponseSuccess(http.Response response){
    return (response.statusCode == STATUS_CODE_SUCCESS);
  }
}