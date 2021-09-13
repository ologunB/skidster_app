class LoadsModel {
  String id;
  String title;
  int skids;
  String weight;
  String pickup;
  String dropoff;
  int price;
  String name;
  String phone;
  int updatedAt;
  int dateTime;
  int stage;
  String loaderUid;
  String image;
  String truckerName;
  String truckerUid;
  String truckerPhone;
  bool isBooked;
  Map<String, dynamic> location;

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
    this.loaderUid,
    this.image,
    this.pickup,
    this.dateTime,
    this.isBooked,
    this.truckerName,
    this.truckerPhone,
    this.truckerUid,
    this.location,
    this.stage = 0,
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
    loaderUid = json['uid'];
    image = json['image'];
    dateTime = json['date_time'];
    isBooked = json['is_booked'];
    stage = json['stage'] ?? 0;
    truckerName = json['trucker_name'];
    truckerPhone = json['trucker_phone'];
    truckerUid = json['trucker_uid'];
    location = json['_geoloc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['dropoff'] = this.dropoff;
    data['name'] = this.name;
    data['price'] = this.price;
    data['image'] = this.image;
    data['phone'] = this.phone;
    data['title'] = this.title;
    data['stage'] = this.stage;
    data['updated_at'] = this.updatedAt;
    data['skids'] = this.skids;
    data['pickup'] = this.pickup;
    data['weight'] = this.weight;
    data['uid'] = this.loaderUid;
    data['date_time'] = this.dateTime;
    data['is_booked'] = this.isBooked;
    data['trucker_name'] = this.truckerName;
    data['trucker_phone'] = this.truckerPhone;
    data['trucker_uid'] = this.truckerUid;
    data['_geoloc'] = this.location;
    return data;
  }
}

class SkidLocation {
  double lat;
  double lng;

  SkidLocation.fromJson(dynamic json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
  }
}
