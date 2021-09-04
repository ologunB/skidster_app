class UserData {
  int updatedAt;
  String email;

  String plan;
  bool isEmailVerified;
  bool isPhoneVerified;
  String name;
  String phone;
  String type;

  UserData(
      {this.plan,
      this.isEmailVerified,
      this.email,
      this.isPhoneVerified,
      this.updatedAt,
      this.name,
      this.phone,
      this.type});

  UserData.fromJson(dynamic json) {
    plan = json['plan'];
    isEmailVerified = json['is_email_verified'];
    email = json['email'];
    isPhoneVerified = json['is_phone_verified'];
    updatedAt = json['updated_at'];
    name = json['name'];
    phone = json['phone'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['plan'] = this.plan;
    data['is_email_verified'] = this.isEmailVerified;
    data['email'] = this.email;
    data['is_phone_verified'] = this.isPhoneVerified;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['type'] = this.type;
    data['phone'] = this.phone;
    return data;
  }
}
