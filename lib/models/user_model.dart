import 'package:devpush/models/mission_model.dart';

class UserModel {
  int level;
  int devPoints;
  int totalLogin;
  int loginStreak;
  List<MissionModel> missions;

  UserModel(
      {this.level,
      this.devPoints,
      this.totalLogin,
      this.loginStreak,
      this.missions});

  UserModel.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    devPoints = json['devPoints'];
    totalLogin = json['totalLogin'];
    loginStreak = json['loginStreak'];
    if (json['missions'] != null) {
      missions = [];
      json['missions'].forEach((v) {
        missions.add(new MissionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = this.level;
    data['devPoints'] = this.devPoints;
    data['totalLogin'] = this.totalLogin;
    data['loginStreak'] = this.loginStreak;
    if (this.missions != null) {
      data['missions'] = this.missions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
