class StringUtil {
  static int stringToInt(String text){
    int tryParseString = int.tryParse(text.replaceAll(",", ""));

    if( tryParseString != null ){
      return int.parse(text.replaceAll(",", ""));
    }    
    return 0;
  }
}