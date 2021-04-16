class GithubUserModel {
  int id;
  String login;
  String name;
  String avatarUrl;
  String updatedAt;

  GithubUserModel(
      {this.id, this.login, this.name, this.avatarUrl, this.updatedAt});

  GithubUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    name = json['name'];
    avatarUrl = json['avatar_url'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['login'] = this.login;
    data['name'] = this.name;
    data['avatar_url'] = this.avatarUrl;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
