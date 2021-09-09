class NewMessageModel {
  NewMessageModel({
    this.text,
    this.type,
    this.createdAt,
    this.from,
    this.to,
    this.isRead,
    this.data,
    this.fromName,
    this.toName,
    this.fromImg,
    this.toImg,
    this.mediaLink,
    this.replyBody,
    this.me,
    this.replyTitle,
    this.size,
    this.fileName,
  });

  NewMessageModel.fromJson(dynamic json) {
    type = json['type'] as String;
    replyTitle = json['replyTitle'] as String;
    replyBody = json['replyBody'] as String;
    text = json['text'] as String;
    createdAt = json['createdAt'] as int;
    from = json['from'] as String;
    fromName = json['fromName'] as String;
    fromImg = json['fromImg'] as String;
    mediaLink = json['media'] as String;
    to = json['to'] as String;
    toName = json['toName'] as String;
    toImg = json['toImg'] as String;
    isRead = json['isRead'] as bool;
    size = json['size'] as String;
    data = json['data'];

    fileName = json['fileName'] as String;
  }

  String type;
  String fileName;
  String mediaLink;
  String me;
  String replyBody;
  String replyTitle;
  String text;
  int createdAt;
  String from;
  String fromName;
  String fromImg;
  String to;
  String toName;
  String toImg;
  String size;
  dynamic data;
  bool isRead;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['replyTitle'] = replyTitle;
    data['replyBody'] = replyBody;
    data['fileName'] = fileName;
    data['type'] = type;
    data['text'] = text;
    data['createdAt'] = createdAt;
    data['from'] = from;
    data['fromName'] = fromName;
    data['fromImg'] = fromImg;
    data['media'] = mediaLink;
    data['to'] = to;
    data['toName'] = toName;
    data['toImg'] = toImg;
    data['isRead'] = isRead;
    data['size'] = size;
    return data;
  }
}
