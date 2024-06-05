class HttpResponseFlutter{
  int? statusCode;
  Map<String, dynamic>? result;
  String? errorMessage;
  bool? isLoading;
  HttpResponseFlutter({
    this.result,
    this.statusCode,
    this.errorMessage,
    this.isLoading
  });

  HttpResponseFlutter.unknown():result =null, statusCode = null, errorMessage =null, isLoading = false;

  void update({
    Map<String,dynamic>? result,
    int? statusCode,
    String? errorMessage,
    bool? isLoading
  }){
    this.result = result ?? this.result;
    this.statusCode = statusCode ?? this.statusCode;
    this.errorMessage = errorMessage ?? this.errorMessage;
    this.isLoading =  isLoading ?? this.isLoading;
  }
}