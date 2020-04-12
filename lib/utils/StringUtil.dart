class StringUtil {
  static int stringToInt(String text){
    return int.parse(text.replaceAll(",", ""));
  }
}