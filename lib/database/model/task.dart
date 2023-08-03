class Task {
  static const String collectionName = 'tasks';
  String? id;
  String? title;
  String? desc;
  DateTime? dateTime;
  bool? isDone;

  Task({this.dateTime, this.id, this.title, this.desc, this.isDone = false});

  Task.fromFireStore(Map<String, dynamic>? date)
      : this(
            id: date?['id'],
            desc: date?['desc'],
            title: date?['title'],
            isDone: date?['isDone'],
            dateTime: DateTime.fromMillisecondsSinceEpoch(date?['date']));

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'desc': desc,
      'title': title,
      'isDone': isDone,
      'date': dateTime?.millisecondsSinceEpoch,
    };
  }
}
