class UserModel {
  int id;
  String login;
  String avatarUrl;
  String bio;
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
  String visitCard;
  int totalRatedQuizzes;

  UserModel({
    this.id,
    this.login,
    this.avatarUrl,
    this.bio,
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
    this.visitCard,
    this.totalRatedQuizzes,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    avatarUrl = json['avatarUrl'];
    bio = json['bio'];
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
    visitCard = json['visitCard'];
    totalRatedQuizzes = json['totalRatedQuizzes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['login'] = this.login;
    data['avatarUrl'] = this.avatarUrl;
    data['bio'] = this.bio;
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
    data['visitCard'] = this.visitCard;
    data['totalRatedQuizzes'] = this.totalRatedQuizzes;
    return data;
  }
}
