import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/constants.dart';
import 'package:todo_list/models/todo.dart';

class Database {
  static final Database _database = Database._internal();

  factory Database() {
    return _database;
  }

  Database._internal();

  Future<bool> init() async {
    await Hive.initFlutter();
    print("after call");
    Hive.registerAdapter<Todo>(TodoAdapter());
    await Hive.openBox<Todo>(todoBox);
    return true;
  }

  Future<Box<Todo>> getBox() async {
    return Hive.box<Todo>(todoBox);
  }
}
