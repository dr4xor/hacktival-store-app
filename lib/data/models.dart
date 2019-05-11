class App{
  int id;
  String link;
  int score;
  List<Tag> tags;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is App &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  App({this.id, this.link, this.score, this.tags});

  App.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    link = json['link'];
    score = json['score'];
    if (json['tags'] != null) {
      tags = new List<Tag>();
      json['tags'].forEach((v) {
        tags.add(new Tag.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['link'] = this.link;
    data['score'] = this.score;
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tag {
  int id;
  String name;

  Tag({this.id, this.name});


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Tag &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;


  Tag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class PlayStoreEntry {
  String appId;
  String title;
  String icon;
  String video;
  String price;
  String description;

  PlayStoreEntry(
      {this.appId,
        this.title,
        this.icon,
        this.video,
        this.price,
        this.description});

  PlayStoreEntry.fromJson(Map<String, dynamic> json) {
    appId = json['app_id'];
    title = json['title'];
    icon = json['icon'];
    video = json['video'];
    price = json['price'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_id'] = this.appId;
    data['title'] = this.title;
    data['icon'] = this.icon;
    data['video'] = this.video;
    data['price'] = this.price;
    data['description'] = this.description;
    return data;
  }
}