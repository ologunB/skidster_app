class NotifiModel {
  String title;
  String person;
  int updatedAt;

  NotifiModel({
    this.title,
    this.updatedAt,this.person
  });

  NotifiModel.fromJson(dynamic json) {
    person = json['person'];
    title = json['text'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['text'] = this.title;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
