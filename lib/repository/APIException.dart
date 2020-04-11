class APIException implements Exception {
  String _message;

  APIException(this._message);

  String toString(){
    return "Exception: $_message";
  }
}