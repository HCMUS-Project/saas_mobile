class FlutterException implements Exception{
  final dynamic _message;
  final dynamic _statusCode;
  FlutterException([this._message, this._statusCode]);

  @override
  String toString() {
    Object? message = _message;
    if (message == null) return "Exception";
    return "Exception: $message";
  }

  Map<String,dynamic> toJson(){
    Object? message = _message;
    if (message == null) return {"error": "Exception"};
    return {
      "message": message,
      "statusCode":_statusCode
    };
  }
}
