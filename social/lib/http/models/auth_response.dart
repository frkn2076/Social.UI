class AuthResponse<T> {
  String? accessToken;
  int? accessTokenExpireDate;
  String? refreshToken;
  int? refreshTokenExpireDate;

  AuthResponse({this.accessToken, this.accessTokenExpireDate, this.refreshToken, this.refreshTokenExpireDate});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    accessTokenExpireDate = json['accessTokenExpireDate'];
    refreshToken = json['refreshToken'];
    refreshTokenExpireDate = json['refreshTokenExpireDate'];
  }
}