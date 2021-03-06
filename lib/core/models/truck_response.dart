class TruckModel {
  String id;
  int experience;
  int isInsured;
  int skids;
  String travelPref;
  String truckType;
  String address;
  String name;
  String companyName;
  String phone;
  int updatedAt;
  String uid;
  String image;
  dynamic position;

  TruckModel({
    this.id,
    this.address,
    this.companyName,this.name,
    this.isInsured,
    this.phone,
    this.experience,
    this.updatedAt,
    this.travelPref,
    this.skids,
    this.uid,
    this.truckType,this.image, this.position,
  });

  TruckModel.fromJson(dynamic json) {
    id = json['id'];
    address = json['address'];
    name = json['name'];
    companyName = json['company_name'];
    isInsured = json['is_insured'];
    phone = json['phone'];
    experience = json['experience'];
    updatedAt = json['updated_at'];
    skids = json['skids'];
    image = json['image'];
    truckType = json['truck_type'];
    travelPref = json['travel_pref'];
    uid = json['uid'];
    position = json['_geoloc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_geoloc'] = this.position;
    data['id'] = this.id;
    data['address'] = this.address;
    data['name'] = this.name;
    data['company_name'] = this.companyName;
    data['is_insured'] = this.isInsured;
    data['phone'] = this.phone;
    data['experience'] = this.experience;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    data['skids'] = this.skids;
    data['truck_type'] = this.truckType;
    data['travel_pref'] = this.travelPref;
    data['uid'] = this.uid;
    return data;
  }
}
