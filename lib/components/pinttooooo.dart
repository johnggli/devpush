class GithubUserModel {
  int id;
  String login;
  String name;
  String avatarUrl;
  String bio;
  int following;
  String updatedAt;

  GithubUserModel({
    this.id,
    this.login,
    this.name,
    this.avatarUrl,
    this.bio,
    this.following,
    this.updatedAt,
  });

  GithubUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    name = json['name'];
    avatarUrl = json['avatar_url'];
    bio = json['bio'];
    following = json['following'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['login'] = this.login;
    data['name'] = this.name;
    data['avatar_url'] = this.avatarUrl;
    data['bio'] = this.bio;
    data['following'] = this.following;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
