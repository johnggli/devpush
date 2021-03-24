class Contribution {
  int count;
  String color;
  String date;

  Contribution({this.count, this.color, this.date});

  Contribution.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    color = json['color'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['color'] = this.color;
    data['date'] = this.date;
    return data;
  }
}
