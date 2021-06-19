class Todo {
  Todo({
    required this.id,
    required this.name,
    this.description = "",
    this.date = "",
    this.time = "",
    this.completed = false,
  });

  final String id;
  final String name;
  final String description;
  final String date;
  final String time;
  final bool completed;

  @override
  String toString() {
    return 'Todo(name: $name, description: $description, date: $date, time: $time, completed: $completed)';
  }
}
