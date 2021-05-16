class UserModel {
  int level;
  int devPoints;
  int devCoins;
  int totalLogin;
  int loginStreak;

  UserModel({
    this.level,
    this.devPoints,
    this.devCoins,
    this.totalLogin,
    this.loginStreak,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    devPoints = json['devPoints'];
    devCoins = json['devCoins'];
    totalLogin = json['totalLogin'];
    loginStreak = json['loginStreak'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = this.level;
    data['devPoints'] = this.devPoints;
    data['devCoins'] = this.devCoins;
    data['totalLogin'] = this.totalLogin;
    data['loginStreak'] = this.loginStreak;
    return data;
  }
}
