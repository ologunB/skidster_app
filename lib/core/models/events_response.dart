class EventsResponse {
  bool status;
  String message;
  List<EventModel> data;

  EventsResponse({this.status, this.message, this.data});

  EventsResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EventModel>[];
      json['data'].forEach((v) {
        data.add(new EventModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventModel {
  int id;
  String title;
  String description;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  bool isRepetitive;
  String repeatInterval;
  List<int> checkIn;
  int churchId;
  String createdAt;
  String updatedAt;
  List<Pictures> pictures;

  EventModel(
      {this.id,
      this.title,
      this.description,
      this.startDate,
      this.endDate,
      this.startTime,
      this.endTime,
      this.isRepetitive,
      this.repeatInterval,
      this.checkIn,
      this.churchId,
      this.createdAt,
      this.updatedAt,
      this.pictures});

  EventModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    isRepetitive = json['is_repetitive'];
    repeatInterval = json['repeat_interval'];
    checkIn = json['check_in'].cast<int>();
    churchId = json['church_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['pictures'] != null) {
      pictures = <Pictures>[];
      json['pictures'].forEach((v) {
        pictures.add(new Pictures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['is_repetitive'] = this.isRepetitive;
    data['repeat_interval'] = this.repeatInterval;
    data['check_in'] = this.checkIn;
    data['church_id'] = this.churchId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pictures != null) {
      data['pictures'] = this.pictures.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pictures {
  int id;
  String url;
  String fileId;
  String thumbnailUrl;
  int eventId;
  int width;
  int height;
  int size;
  String name;
  String filePath;
  String fileType;
  String createdAt;
  String updatedAt;

  Pictures(
      {this.id,
      this.url,
      this.fileId,
      this.thumbnailUrl,
      this.eventId,
      this.width,
      this.height,
      this.size,
      this.name,
      this.filePath,
      this.fileType,
      this.createdAt,
      this.updatedAt});

  Pictures.fromJson(dynamic json) {
    id = json['id'];
    url = json['url'];
    fileId = json['file_id'];
    thumbnailUrl = json['thumbnail_url'];
    eventId = json['event_id'];
    width = json['width'];
    height = json['height'];
    size = json['size'];
    name = json['name'];
    filePath = json['file_path'];
    fileType = json['file_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['file_id'] = this.fileId;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['event_id'] = this.eventId;
    data['width'] = this.width;
    data['height'] = this.height;
    data['size'] = this.size;
    data['name'] = this.name;
    data['file_path'] = this.filePath;
    data['file_type'] = this.fileType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
