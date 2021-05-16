class UserModel {
  int level;
  int devPoints;
  int devCoins;
  String lastLogin;
  int totalLogin;
  int loginStreak;
  int wins;

  UserModel({
    this.level,
    this.devPoints,
    this.devCoins,
    this.lastLogin,
    this.totalLogin,
    this.loginStreak,
    this.wins,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    devPoints = json['devPoints'];
    devCoins = json['devCoins'];
    lastLogin = json['lastLogin'];
    totalLogin = json['totalLogin'];
    loginStreak = json['loginStreak'];
    wins = json['wins'];
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
    return data;
  }
}
