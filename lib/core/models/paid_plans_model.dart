class PaidPlansModel {
  String title;
  String id;

  int price;
  int updatedAt;
  int duration;

  bool isRead;

  PaidPlansModel({this.title, this.updatedAt, this.price, this.id, this.duration, this.isRead});

  PaidPlansModel.fromJson(dynamic json) {
    price = json['price'];
    title = json['title'];
    id = json['id'];
    duration = json['load_id'];
    isRead = json['is_read'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this.title;
    data['id'] = this.id;
    data['is_read'] = this.isRead;

    data['duration'] = this.duration;
    data['price'] = this.price;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
