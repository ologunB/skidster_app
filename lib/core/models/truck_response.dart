class TruckModel {
  String id;
  String experience;
  int isInsured;
  String skids;
  String travelPref;
  String truckType;
  String address;
  String companyName;
  String companyPhone;
  int updatedAt;
  String uid;

  TruckModel({
    this.id,
    this.address,
    this.companyName,
    this.isInsured,
    this.companyPhone,
    this.experience,
    this.updatedAt,
    this.travelPref,
    this.skids,
    this.uid,
    this.truckType,
  });

  TruckModel.fromJson(dynamic json) {
    id = json['id'];
    address = json['address'];
    companyName = json['company_name'];
    isInsured = json['is_insured'];
    companyPhone = json['company_phone'];
    experience = json['experience'];
    updatedAt = json['updated_at'];
    skids = json['skids'];
    truckType = json['truck_type'];
    travelPref = json['travel_pref'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['company_name'] = this.companyName;
    data['is_insured'] = this.isInsured;
    data['company_phone'] = this.companyPhone;
    data['experience'] = this.experience;
    data['updated_at'] = this.updatedAt;
    data['skids'] = this.skids;
    data['truck_type'] = this.truckType;
    data['travel_pref'] = this.travelPref;
    data['uid'] = this.uid;
    return data;
  }
}
