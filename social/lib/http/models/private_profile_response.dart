class PrivateProfileResponse {
  int? id;
  String? userName;
  String? email;
  String? password;
  String? photo;
  String? name;
  String? about;

  PrivateProfileResponse(
      {this.id,
      this.userName,
      this.email,
      this.password,
      this.photo,
      this.name,
      this.about});

  PrivateProfileResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    email = json['email'];
    password = json['password'];
    photo = json['photo'];
    name = json['name'];
    about = json['about'];
  }
}