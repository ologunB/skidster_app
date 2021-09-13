class UserData {
  int updatedAt;
  String email;
  String companyName;
  String companyPhone;
  String companyAddress;
  String plan;
  String carrierDocs;
  String driverLicense;
  String name;
  String phone;
  String type;
  String uid;
  String image;
  dynamic location;

  UserData(
      {this.plan,
      this.carrierDocs,
      this.email,
      this.driverLicense,
      this.updatedAt,
      this.name,
      this.phone,
      this.type,
      this.companyPhone,
      this.companyName,this.uid,
      this.companyAddress, this.image, this.location,});

  UserData.fromJson(dynamic json) {
    plan = json['plan'];
    carrierDocs = json['carrier_doc'];
    email = json['email'];
    driverLicense = json['driver_license'];
    updatedAt = json['updated_at'];
    name = json['name'];
    companyName = json['company_name'];
    companyAddress = json['company_address'];
    companyPhone = json['company_phone'];
    phone = json['phone'];
    uid = json['uid'];
    type = json['type'];
    image = json['image'];
    location = json['_geoloc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['plan'] = this.plan;
    data['carrier_doc'] = this.carrierDocs;
    data['email'] = this.email;
    data['driver_license'] = this.driverLicense;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['company_name'] = this.companyName;
    data['company_address'] = this.companyAddress;
    data['company_phone'] = this.companyPhone;
    data['type'] = this.type;
    data['phone'] = this.phone;
    data['uid'] = this.uid;
    data['image'] = this.image;
    data['_geoloc'] = this.location;
    return data;
  }
}
