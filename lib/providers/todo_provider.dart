import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/state.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// An object that controls a list of [Todo].
class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier([List<Todo>? initialTodos]) : super(initialTodos ?? []);

  void add({required String name, description, date, time}) {
    state = [
      ...state,
      Todo(
        id: _uuid.v4(),
        name: name,
        description: description ?? "",
        date: date ?? "",
        time: time ?? "",
      ),
    ];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: !todo.completed,
            name: todo.name,
            description: todo.description,
            date: todo.date,
            time: todo.time,
          )
        else
          todo,
    ];
  }

  void edit({
    required String id,
    name,
    description,
    date,
    time,
  }) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: todo.completed,
            name: name ?? todo.name,
            description: description ?? todo.description,
            date: date ?? todo.date,
            time: time ?? todo.time,
          )
        else
          todo,
    ];
  }

  void remove(Todo target) {
    state = state.where((todo) => todo.id != target.id).toList();
  }
}

final activeTodosCount = Provider<int>((ref) {
  return ref.watch(todoListProvider).where((todo) => !todo.completed).length;
});

enum Filter { all, active, completed }

final filterProvider = StateProvider((_) => Filter.all);

final searchProvider = StateProvider((_) => "");

final filteredTodoListProvider = Provider<List<Todo>>((ref) {
  final filter = ref.watch(filterProvider);
  final search = ref.watch(searchProvider);
  final todos = ref.watch(todoListProvider);

  List<Todo> filteredTodos;

  switch (filter.state) {
    case Filter.all:
      filteredTodos = todos;
      break;
    case Filter.active:
      filteredTodos = todos.where((todo) => !todo.completed).toList();
      break;
    case Filter.completed:
    default:
      filteredTodos = todos.where((todo) => todo.completed).toList();
      break;
  }

  if (search.state.isEmpty) {
    return filteredTodos;
  } else {
    return filteredTodos
        .where((todo) =>
            todo.name.toLowerCase().contains(search.state.toLowerCase()))
        .toList();
  }
});
