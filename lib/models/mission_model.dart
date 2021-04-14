class MissionModel {
  int id;
  int level;
  int currentGoal;
  bool isCompleted;

  MissionModel({this.id, this.level, this.currentGoal, this.isCompleted});

  MissionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level = json['level'];
    currentGoal = json['currentGoal'];
    isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['level'] = this.level;
    data['currentGoal'] = this.currentGoal;
    data['isCompleted'] = this.isCompleted;
    return data;
  }
}
