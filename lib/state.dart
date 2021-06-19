import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'models/todo.dart';
import 'providers/todo_provider.dart';

final todoListProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>(
  (ref) => TodoListNotifier([
    Todo(
        id: 'todo-0',
        name: "Flutter TodoList Project",
        description: 'hi',
        date: "27th Jun",
        time: "9:00am"),
    Todo(id: 'todo-1', name: "Write Portfolio Website", description: 'hi'),
    Todo(id: 'todo-2', name: "Learn Containers", description: 'hi'),
  ]),
);
