class UserModel {
  String sub;
  String nickname;
  String name;
  String picture;
  String updatedAt;

  UserModel({this.sub, this.nickname, this.name, this.picture, this.updatedAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    sub = json['sub'];
    nickname = json['nickname'];
    name = json['name'];
    picture = json['picture'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sub'] = this.sub;
    data['nickname'] = this.nickname;
    data['name'] = this.name;
    data['picture'] = this.picture;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
