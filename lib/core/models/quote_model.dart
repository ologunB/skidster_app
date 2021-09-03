class QuoteResponse {
  bool status;
  String message;
  QuoteModel data;

  QuoteResponse({this.status, this.message, this.data});

  QuoteResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new QuoteModel.fromJson(json['data']) : null;
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

class QuoteModel {
  int id;
  String content;
  bool isTodayQuote;
  int churchId;
  String createdAt;
  String updatedAt;

  QuoteModel(
      {this.id,
      this.content,
      this.isTodayQuote,
      this.churchId,
      this.createdAt,
      this.updatedAt});

  QuoteModel.fromJson(dynamic json) {
    id = json['id'];
    content = json['content'];
    isTodayQuote = json['is_today_quote'];
    churchId = json['church_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['is_today_quote'] = this.isTodayQuote;
    data['church_id'] = this.churchId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
