class HomeChatModel {
  HomeChatModel(
      {this.toUid,
      this.lastText,
      this.fromUid,
      this.createdAt,
      this.messagingToken,
      this.isRead,
      this.toImg,
      this.isGroup,
      this.toName,
      this.fromName,
      this.id,
      this.fromImg});

  HomeChatModel.fromJson(dynamic json) {
    isGroup = json['isGroup'] as bool;
    id = json['id'] as String;
    toUid = json['to'] as String;
    toName = json['toName'] as String;
    toImg = json['toImg'] as String;
    lastText = json['text'] as String;
    createdAt = json['createdAt'] as int;
    fromUid = json['from'] as String;
    messagingToken = json['messagingToken'] as String;
    fromName = json['fromName'] as String;
    fromImg = json['fromImg'] as String;
    isRead = json['isRead'];
  }

  String id;
  bool isGroup;
  String toUid;
  String toName;
  String toImg;
  String lastText;
  int createdAt;
  String fromUid;
  String messagingToken;
  String fromName;
  String fromImg;
  bool isRead;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isGroup'] = isGroup;
    data['messagingToken'] = messagingToken;
    data['to'] = toUid;
    data['toName'] = toName;
    data['toImg'] = toImg;
    data['text'] = lastText;
    data['createdAt'] = createdAt;
    data['from'] = fromUid;
    data['fromName'] = fromName;
    data['fromImg'] = fromImg;
    data['isRead'] = isRead;
    return data;
  }
}
