class AllActivityResponse {
  int? id;
  String? title;
  String? detail;
  String? location;
  String? date;

  AllActivityResponse({this.id, this.title, this.detail, this.location, this.date});

  AllActivityResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    detail = json['detail'];
    location = json['location'];
    date = json['date'];
  }
}