class GenericResponse<T> {
  bool? isSuccessful;
  String? error;
  T? response;

  GenericResponse({this.isSuccessful, this.error, this.response});

  static GenericResponse createSuccessResponse<T>(T response){
    return GenericResponse<T>(isSuccessful: true, response: response);
  }

  static GenericResponse createFailResponse<T>(String error){
    return GenericResponse<T>(isSuccessful: false, error: error);
  }

  GenericResponse.fromJson(Map<String, dynamic> json) {
    isSuccessful = json['IsSuccessful'];
    error = json['Error'];
    response = json['Response'];
  }
}
