class UserModel {
  int level;
  int devPoints;
  int devCoins;
  String lastLogin;
  int totalLogin;
  int loginStreak;
  int wins;
  int following;
  int completedMissions;
  int totalCreatedQuizzes;
  int totalPostPoints;

  UserModel({
    this.level,
    this.devPoints,
    this.devCoins,
    this.lastLogin,
    this.totalLogin,
    this.loginStreak,
    this.wins,
    this.following,
    this.completedMissions,
    this.totalCreatedQuizzes,
    this.totalPostPoints,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    devPoints = json['devPoints'];
    devCoins = json['devCoins'];
    lastLogin = json['lastLogin'];
    totalLogin = json['totalLogin'];
    loginStreak = json['loginStreak'];
    wins = json['wins'];
    following = json['following'];
    completedMissions = json['completedMissions'];
    totalCreatedQuizzes = json['totalCreatedQuizzes'];
    totalPostPoints = json['totalPostPoints'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = this.level;
    data['devPoints'] = this.devPoints;
    data['devCoins'] = this.devCoins;
    data['lastLogin'] = this.lastLogin;
    data['totalLogin'] = this.totalLogin;
    data['loginStreak'] = this.loginStreak;
    data['wins'] = this.wins;
    data['following'] = this.following;
    data['completedMissions'] = this.completedMissions;
    data['totalCreatedQuizzes'] = this.totalCreatedQuizzes;
    data['totalPostPoints'] = this.totalPostPoints;
    return data;
  }
}
