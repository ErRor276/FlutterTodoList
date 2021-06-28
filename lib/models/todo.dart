import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 1)
class Todo extends HiveObject {
  Todo({
    required this.id,
    required this.name,
    this.description = "",
    this.date = "",
    this.time = "",
    this.completed = false,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String date;
  @HiveField(4)
  final String time;
  @HiveField(5)
  final bool completed;

  @override
  String toString() {
    return 'Todo(key: $key, name: $name, description: $description, date: $date, time: $time, completed: $completed)';
  }
}
