class Mission {
  int id;
  String title;
  // String iconUrl;
  // String iconCompletedUrl;
  int level;
  int current;
  List goals; // [3, 5, 7, 10, 15]
  bool completed;

  Mission(this.id, this.title, this.level, this.current, this.goals,
      this.completed);
}
