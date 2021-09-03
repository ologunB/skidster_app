class VideoResponse {
  String nextToken;
  List<VideoModel> data;

  VideoResponse({this.nextToken, this.data});

  VideoResponse.fromJson(dynamic json) {
    nextToken = json['nextPageToken'];
    if (json['items'] != null) {
      data = <VideoModel>[];
      json['items'].forEach((v) {
        data.add(VideoModel.fromJson(v));
      });
    }
  }
}

class VideoModel {
  String url;
  String image;
  String title;
  String timeCreated;
  String owner;
  String desc;

  VideoModel(
      {this.url,
      this.image,
      this.title,
      this.timeCreated,
      this.owner,
      this.desc});

  VideoModel.fromJson(dynamic json) {
    url = json['contentDetails']['videoId'];
    timeCreated = json['snippet']['publishedAt'];
    image = json['snippet']['thumbnails']['high']['url'];
    title = json['snippet']['title'];
    owner = json['snippet']['channelTitle'];
    desc = json['snippet']['description'];
  }

  VideoModel.fromSavedJson(dynamic json) {
    url = json['videoId'];
    timeCreated = json['publishedAt'];
    image = json['url'];
    title = json['title'];
    owner = json['channelTitle'];
    desc = json['description'];
  }

  Map<String, dynamic> toSavedJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['videoId'] = url;
    data['publishedAt'] = timeCreated;
    data['url'] = image;
    data['title'] = title;
    data['channelTitle'] = owner;
    data['description'] = desc;
    return data;
  }
}
