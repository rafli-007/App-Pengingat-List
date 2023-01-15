class Task {
  int? id;
  String title;
  String category;
  int done;
  String taskDate;

  Task({
    this.id,
    required this.title,
    required this.category,
    required this.done,
    required this.taskDate,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'category': category,
        'done': done,
        'taskDate': taskDate,
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        id: map['id'],
        title: map['title'],
        category: map['category'],
        done: map['done'],
        taskDate: map['taskDate'],
      );
}
