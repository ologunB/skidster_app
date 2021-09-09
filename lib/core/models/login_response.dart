class UserData {
  int updatedAt;
  String email;
  String companyName;
  String companyPhone;
  String companyAddress;
  String plan;
  bool isEmailVerified;
  bool isPhoneVerified;
  String name;
  String phone;
  String type;
  String uid;
  String image;

  UserData(
      {this.plan,
      this.isEmailVerified,
      this.email,
      this.isPhoneVerified,
      this.updatedAt,
      this.name,
      this.phone,
      this.type,
      this.companyPhone,
      this.companyName,this.uid,
      this.companyAddress, this.image});

  UserData.fromJson(dynamic json) {
    plan = json['plan'];
    isEmailVerified = json['is_email_verified'];
    email = json['email'];
    isPhoneVerified = json['is_phone_verified'];
    updatedAt = json['updated_at'];
    name = json['name'];
    companyName = json['company_name'];
    companyAddress = json['company_address'];
    companyPhone = json['company_phone'];
    phone = json['phone'];
    uid = json['uid'];
    type = json['type'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['plan'] = this.plan;
    data['is_email_verified'] = this.isEmailVerified;
    data['email'] = this.email;
    data['is_phone_verified'] = this.isPhoneVerified;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['company_name'] = this.companyName;
    data['company_address'] = this.companyAddress;
    data['company_phone'] = this.companyPhone;
    data['type'] = this.type;
    data['phone'] = this.phone;
    data['uid'] = this.uid;
    data['image'] = this.image;
    return data;
  }
}
