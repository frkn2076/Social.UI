class Response<T> {
  bool? isSuccessful;
  String? error;
  T? response;

  Response({this.isSuccessful, this.error, this.response});

  Response.fromJson(Map<String, dynamic> json) {
    isSuccessful = json['IsSuccessful'];
    error = json['Error'];
    response = json['Response'];
  }
}