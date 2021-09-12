class NotifiModel {
  String title;
  String person;
  int updatedAt;
  String id;
  String loadId;
  bool isRead;

  NotifiModel({
    this.title,
    this.updatedAt,
    this.person,
    this.id,
    this.loadId,
    this.isRead,
  });

  NotifiModel.fromJson(dynamic json) {
    person = json['fromName'];
    title = json['text'];
    id = json['id'];
    loadId = json['load_id'];
    isRead = json['is_read'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['text'] = this.title;
    data['id'] = this.id;
    data['load_id'] = this.loadId;
    data['is_read'] = this.isRead;
    data['fromName'] = this.person;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
