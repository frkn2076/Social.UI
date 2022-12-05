class ActivityDetailResponse {
  int? id;
  String? title;
  String? detail;
  String? location;
  DateTime? date;
  int? userId;
  String? phoneNumber;
  String? category;
  List<Joiners>? joiners;

  ActivityDetailResponse(
      {this.id,
      this.title,
      this.detail,
      this.location,
      this.date,
      this.userId,
      this.phoneNumber,
      this.category,
      this.joiners});

  ActivityDetailResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    detail = json['detail'];
    location = json['location'];
    date = json['date'] == null ? null : DateTime.parse(json['date']);
    userId = json['userId'];
    phoneNumber = json['phoneNumber'];
    category = json['category'];
    if (json['joiners'] != null) {
      joiners = <Joiners>[];
      json['joiners'].forEach((v) {
        joiners!.add(Joiners.fromJson(v));
      });
    }
  }
}

class Joiners {
  int? id;
  String? userName;

  Joiners({this.id, this.userName});

  Joiners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
  }
}
