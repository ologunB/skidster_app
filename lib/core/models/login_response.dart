class LoginResponse {
  bool status;
  String message;
  LoginData data;

  LoginResponse({this.status, this.message, this.data});

  LoginResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class LoginData {
  int id;
  String token;
  String email;
  String createdAt;
  String updatedAt;
  String role;
  int churchId;
  Profile profile;
  Church church;
  List<Group> groups;
  List<Subgroup> subgroups;
  int allGroups;

  LoginData(
      {this.id,
      this.token,
      this.email,
      this.createdAt,
      this.updatedAt,
      this.role,
      this.churchId,
      this.profile,
      this.church,
      this.groups,
      this.subgroups,
      this.allGroups});

  LoginData.fromJson(dynamic json) {
    id = json['id'];
    token = json['token'];
    email = json['email'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    role = json['role'];
    churchId = json['church_id'];
    allGroups = json['all_groups'];
    if (json['subgroups'] != null) {
      subgroups = <Subgroup>[];
      json['subgroups'].forEach((v) {
        subgroups.add(Subgroup.fromJson(v));
      });
    }

    if (json['groups'] != null) {
      groups = <Group>[];
      json['groups'].forEach((v) {
        groups.add(Group.fromJson(v));
      });
    }

    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    church = json['church'] != null ? Church.fromJson(json['church']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['token'] = this.token;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['role'] = this.role;
    data['church_id'] = this.churchId;
    if (this.profile != null) {
      data['profile'] = this.profile.toJson();
    }
    if (this.church != null) {
      data['church'] = this.church.toJson();
    }
    return data;
  }
}

class Profile {
  int id;
  String firstName;
  String lastName;
  String fullName;
  String mobilePhone;
  String homeNumber;
  String address;
  String workNumber;
  int userId;
  String profession;
  String maritalStatus;
  String gender;
  int age;
  String dob;
  int churchId;
  bool archived;
  String inviteStatus;
  String createdAt;
  String updatedAt;
  String location;
  String bloodType;
  String churchPosition;
  Picture picture;

  Profile(
      {this.id,
      this.firstName,
      this.lastName,
      this.fullName,
      this.mobilePhone,
      this.homeNumber,
      this.workNumber,
      this.userId,
      this.profession,
      this.maritalStatus,
      this.gender,
      this.age,
      this.dob,
      this.address,
      this.churchId,
      this.archived,
      this.inviteStatus,
      this.createdAt,
      this.updatedAt,
      this.picture,
      this.location,
      this.bloodType,
      this.churchPosition});

  Profile.fromJson(dynamic json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    fullName = json['full_name'];
    mobilePhone = json['mobile_phone'];
    homeNumber = json['home_number'];
    workNumber = json['work_number'];
    userId = json['user_id'];
    profession = json['profession'];
    maritalStatus = json['marital_status'];
    address = json['address'];
    gender = json['gender'];
    age = json['age'];
    dob = json['dob'];
    churchId = json['church_id'];
    archived = json['archived'];
    inviteStatus = json['invite_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    location = json['location'];
    bloodType = json['blood_type'];
    churchPosition = json['church_position'];
    picture =
        json['picture'] != null ? new Picture.fromJson(json['picture']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['full_name'] = this.fullName;
    data['mobile_phone'] = this.mobilePhone;
    data['home_number'] = this.homeNumber;
    data['work_number'] = this.workNumber;
    data['user_id'] = this.userId;
    data['profession'] = this.profession;
    data['marital_status'] = this.maritalStatus;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['dob'] = this.dob;
    data['church_id'] = this.churchId;
    data['archived'] = this.archived;
    data['invite_status'] = this.inviteStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['location'] = this.location;
    data['blood_type'] = this.bloodType;
    data['church_position'] = this.churchPosition;
    if (this.picture != null) {
      data['picture'] = this.picture.toJson();
    }
    return data;
  }
}

class Picture {
  int id;
  String url;
  String fileId;
  String thumbnailUrl;
  int profileId;
  int eventId;
  int width;
  int height;
  int size;
  String name;
  String filePath;
  String fileType;
  String createdAt;
  String updatedAt;
  int churchId;

  Picture(
      {this.id,
      this.url,
      this.fileId,
      this.thumbnailUrl,
      this.profileId,
      this.eventId,
      this.width,
      this.height,
      this.size,
      this.name,
      this.filePath,
      this.fileType,
      this.createdAt,
      this.updatedAt,
      this.churchId});

  Picture.fromJson(dynamic json) {
    id = json['id'];
    url = json['url'];
    fileId = json['file_id'];
    thumbnailUrl = json['thumbnail_url'];
    profileId = json['profile_id'];
    eventId = json['event_id'];
    width = json['width'];
    height = json['height'];
    size = json['size'];
    name = json['name'];
    filePath = json['file_path'];
    fileType = json['file_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    churchId = json['church_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['file_id'] = this.fileId;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['profile_id'] = this.profileId;
    data['event_id'] = this.eventId;
    data['width'] = this.width;
    data['height'] = this.height;
    data['size'] = this.size;
    data['name'] = this.name;
    data['file_path'] = this.filePath;
    data['file_type'] = this.fileType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['church_id'] = this.churchId;
    return data;
  }
}

class Church {
  int id;
  String name;
  String email;
  String address;
  String createdAt;
  String updatedAt;
  UiTheme uiTheme;
  int totalGroups;
  int totalSubGroups;
  Logo logo;

  Church(
      {this.id,
      this.name,
      this.email,
      this.address,
      this.createdAt,
      this.updatedAt,
      this.uiTheme,
      this.totalGroups,
      this.totalSubGroups,
      this.logo});

  Church.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    uiTheme = json['ui_theme'] != null
        ? new UiTheme.fromJson(json['ui_theme'])
        : null;
    totalGroups = json['total_groups'];
    totalSubGroups = json['total_subgroups'];
    logo = json['logo'] != null ? Logo.fromJson(json['logo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.uiTheme != null) {
      data['ui_theme'] = this.uiTheme.toJson();
    }
    data['total_groups'] = this.totalGroups;
    data['total_subgroups'] = this.totalSubGroups;
    if (this.logo != null) {
      data['logo'] = this.logo.toJson();
    }
    return data;
  }
}

class UiTheme {
  String primaryColor;
  String secondaryColor;

  UiTheme({this.primaryColor, this.secondaryColor});

  UiTheme.fromJson(dynamic json) {
    primaryColor = json['primaryColor'];
    secondaryColor = json['secondaryColor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['primaryColor'] = this.primaryColor;
    data['secondaryColor'] = this.secondaryColor;
    return data;
  }
}

class Logo {
  int id;
  String url;
  String fileId;
  String thumbnailUrl;
  int profileId;
  int eventId;
  int width;
  int height;
  int size;
  String name;
  String filePath;
  String fileType;
  String createdAt;
  String updatedAt;
  int churchId;

  Logo(
      {this.id,
      this.url,
      this.fileId,
      this.thumbnailUrl,
      this.profileId,
      this.eventId,
      this.width,
      this.height,
      this.size,
      this.name,
      this.filePath,
      this.fileType,
      this.createdAt,
      this.updatedAt,
      this.churchId});

  Logo.fromJson(dynamic json) {
    id = json['id'];
    url = json['url'];
    fileId = json['file_id'];
    thumbnailUrl = json['thumbnail_url'];
    profileId = json['profile_id'];
    eventId = json['event_id'];
    width = json['width'];
    height = json['height'];
    size = json['size'];
    name = json['name'];
    filePath = json['file_path'];
    fileType = json['file_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    churchId = json['church_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['file_id'] = this.fileId;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['profile_id'] = this.profileId;
    data['event_id'] = this.eventId;
    data['width'] = this.width;
    data['height'] = this.height;
    data['size'] = this.size;
    data['name'] = this.name;
    data['file_path'] = this.filePath;
    data['file_type'] = this.fileType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['church_id'] = this.churchId;
    return data;
  }
}

class Group {
  int id;
  String name;
  int churchId;
  String createdAt;
  String updatedAt;
  List<Profile> members;
  List<Subgroup> subgroups;
  int totalSubgroups;
  int totalMembers;

  Group(
      {this.id,
      this.name,
      this.churchId,
      this.createdAt,
      this.updatedAt,
      this.members,
      this.subgroups,
      this.totalSubgroups,
      this.totalMembers});

  Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    churchId = json['church_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['members'] != null) {
      members = <Profile>[];
      json['members'].forEach((v) {
        members.add(Profile.fromJson(v));
      });
    }
    if (json['subgroups'] != null) {
      subgroups = <Subgroup>[];
      json['subgroups'].forEach((v) {
        subgroups.add(Subgroup.fromJson(v));
      });
    }
    totalSubgroups = json['total_subgroups'];
    totalMembers = json['total_members'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['church_id'] = this.churchId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    if (this.subgroups != null) {
      data['subgroups'] = this.subgroups.map((v) => v.toJson()).toList();
    }
    data['total_subgroups'] = this.totalSubgroups;
    data['total_members'] = this.totalMembers;
    return data;
  }
}

class Subgroup {
  int id;
  String name;
  int churchId;
  int groupId;
  String createdAt;
  String updatedAt;
  List<Profile> members;

  Subgroup({
    this.id,
    this.name,
    this.churchId,
    this.createdAt,
    this.updatedAt,
    this.members,
    this.groupId,
  });

  Subgroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    groupId = json['group_id'];
    churchId = json['church_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['members'] != null) {
      members = <Profile>[];
      json['members'].forEach((v) {
        members.add(Profile.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['group_id'] = this.groupId;
    data['church_id'] = this.churchId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserLocation {
  int id;
  String location;

  UserLocation({
    this.id,
    this.location,
  });

  UserLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['location'] = this.location;
    return data;
  }
}
