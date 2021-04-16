class MissionModel {
  int id;
  int level;
  int currentGoal;
  int reward;
  bool isCompleted;

  MissionModel(
      {this.id, this.level, this.currentGoal, this.reward, this.isCompleted});

  MissionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level = json['level'];
    currentGoal = json['currentGoal'];
    reward = json['reward'];
    isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['level'] = this.level;
    data['currentGoal'] = this.currentGoal;
    data['reward'] = this.reward;
    data['isCompleted'] = this.isCompleted;
    return data;
  }
}
