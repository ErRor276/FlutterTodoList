import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'models/todo.dart';
import 'providers/todo_provider.dart';

final todoListProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>(
  (ref) => TodoListNotifier(),
);
