class ConnectResponse {
  bool status;
  String message;
  List<ConnectData> data;

  ConnectResponse({this.status, this.message, this.data});

  ConnectResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ConnectData>[];
      json['data'].forEach((v) {
        data.add(new ConnectData.fromJson(v));
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

class ConnectData {
  int id;
  bool isSpousalConnection;
  int senderId;
  String senderName;
  String receiverName;
  int receiverId;
  String senderFamilyPosition;
  String receiverFamilyPosition;
  String status;
  String createdAt;
  String updatedAt;

  ConnectData(
      {this.id,
      this.isSpousalConnection,
      this.senderId,
      this.senderName,
      this.receiverName,
      this.receiverId,
      this.senderFamilyPosition,
      this.receiverFamilyPosition,
      this.status,
      this.createdAt,
      this.updatedAt});

  ConnectData.fromJson(dynamic json) {
    id = json['id'];
    isSpousalConnection = json['is_spousal_connection'];
    senderId = json['sender_id'];
    senderName = json['sender_name'];
    receiverName = json['receiver_name'];
    receiverId = json['receiver_id'];
    senderFamilyPosition = json['sender_family_position'];
    receiverFamilyPosition = json['receiver_family_position'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_spousal_connection'] = this.isSpousalConnection;
    data['sender_id'] = this.senderId;
    data['sender_name'] = this.senderName;
    data['receiver_name'] = this.receiverName;
    data['receiver_id'] = this.receiverId;
    data['sender_family_position'] = this.senderFamilyPosition;
    data['receiver_family_position'] = this.receiverFamilyPosition;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
