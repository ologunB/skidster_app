class LoadsModel {
  String id;
  String title;
  String skids;
  String weight;
  String pickup;
  String dropoff;
  int price;
  String name;
  String phone;
  int updatedAt;
  int dateTime;
  String uid;

  LoadsModel({
    this.id,
    this.dropoff,
    this.name,
    this.price,
    this.phone,
    this.title,
    this.updatedAt,
    this.weight,
    this.skids,
    this.uid,
    this.pickup,this.dateTime
  });

  LoadsModel.fromJson(dynamic json) {
    id = json['id'];
    dropoff = json['dropoff'];
    name = json['name'];
    price = json['price'];
    phone = json['phone'];
    title = json['title'];
    updatedAt = json['updated_at'];
    skids = json['skids'];
    pickup = json['pickup'];
    weight = json['weight'];
    uid = json['uid'];
    dateTime = json['date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['dropoff'] = this.dropoff;
    data['name'] = this.name;
    data['price'] = this.price;
    data['phone'] = this.phone;
    data['title'] = this.title;
    data['updated_at'] = this.updatedAt;
    data['skids'] = this.skids;
    data['pickup'] = this.pickup;
    data['weight'] = this.weight;
    data['uid'] = this.uid;
    data['date_time'] = this.dateTime;
    return data;
  }
}
