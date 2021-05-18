class UserModel {
  int id;
  String login;
  String name;
  String avatarUrl;
  String bio;
  int following;
  int level;
  int devPoints;
  int devCoins;
  String lastLogin;
  int totalLogin;
  int loginStreak;
  int wins;
  int completedMissions;
  int totalCreatedQuizzes;
  int totalPostPoints;
  int rank;

  UserModel({
    this.id,
    this.login,
    this.name,
    this.avatarUrl,
    this.bio,
    this.following,
    this.devPoints,
    this.devCoins,
    this.lastLogin,
    this.totalLogin,
    this.loginStreak,
    this.wins,
    this.completedMissions,
    this.totalCreatedQuizzes,
    this.totalPostPoints,
    this.rank,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    name = json['name'];
    avatarUrl = json['avatarUrl'];
    bio = json['bio'];
    following = json['following'];
    level = json['level'];
    devPoints = json['devPoints'];
    devCoins = json['devCoins'];
    lastLogin = json['lastLogin'];
    totalLogin = json['totalLogin'];
    loginStreak = json['loginStreak'];
    wins = json['wins'];
    completedMissions = json['completedMissions'];
    totalCreatedQuizzes = json['totalCreatedQuizzes'];
    totalPostPoints = json['totalPostPoints'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['login'] = this.login;
    data['name'] = this.name;
    data['avatarUrl'] = this.avatarUrl;
    data['bio'] = this.bio;
    data['following'] = this.following;
    data['level'] = this.level;
    data['devPoints'] = this.devPoints;
    data['devCoins'] = this.devCoins;
    data['lastLogin'] = this.lastLogin;
    data['totalLogin'] = this.totalLogin;
    data['loginStreak'] = this.loginStreak;
    data['wins'] = this.wins;
    data['completedMissions'] = this.completedMissions;
    data['totalCreatedQuizzes'] = this.totalCreatedQuizzes;
    data['totalPostPoints'] = this.totalPostPoints;
    data['rank'] = this.rank;
    return data;
  }
}
