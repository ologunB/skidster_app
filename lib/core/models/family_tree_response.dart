import 'login_response.dart';

class FamilyTreeResponse {
  bool status;
  String message;
  FamilyData data;

  FamilyTreeResponse({this.status, this.message, this.data});

  FamilyTreeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new FamilyData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class FamilyData {
  int id;
  String name;
  String createdAt;
  String updatedAt;
  List<Members> members;

  FamilyData(
      {this.id, this.name, this.createdAt, this.updatedAt, this.members});

  FamilyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members.add(new Members.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Members {
  int id;
  String email;
  String createdAt;
  String updatedAt;
  String role;
  int churchId;
  Profile profile;
  String familyPosition;

  Members(
      {this.id,
      this.email,
      this.createdAt,
      this.updatedAt,
      this.role,
      this.churchId,
      this.profile,
      this.familyPosition});

  Members.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    role = json['role'];
    churchId = json['church_id'];
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    familyPosition = json['family_position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['role'] = this.role;
    data['church_id'] = this.churchId;
    if (this.profile != null) {
      data['profile'] = this.profile.toJson();
    }
    data['family_position'] = this.familyPosition;
    return data;
  }
}
