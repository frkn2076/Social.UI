class PrivateProfile {
  int? id;
  String? userName;
  String? email;
  String? password;
  String? photo;
  String? name;
  String? surname;
  String? refreshToken;
  String? expireDate;
  String? role;
  String? about;

  PrivateProfile(
      {this.id,
      this.userName,
      this.email,
      this.password,
      this.photo,
      this.name,
      this.surname,
      this.refreshToken,
      this.expireDate,
      this.role,
      this.about});

  PrivateProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    email = json['email'];
    password = json['password'];
    photo = json['photo'];
    name = json['name'];
    surname = json['surname'];
    refreshToken = json['refreshToken'];
    expireDate = json['expireDate'];
    role = json['role'];
    about = json['about'];
  }
}