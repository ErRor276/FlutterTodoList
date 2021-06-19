import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/constants.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/state.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();
var _todoBox;

/// An object that controls a list of [Todo].
class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super([]) {
    init();
  }

  void init() async {
    if (!initiated) {
      initiated = true;
      print("in init");
      await Hive.initFlutter();
      print("after call");
      Hive.registerAdapter<Todo>(TodoAdapter());
      await Hive.openBox<Todo>(todoBox).then((value) {
        print("db called");
        _todoBox = value;
        List<Todo> todos = _todoBox.values.toList();
        state = [...todos];
      });
    }
  }

  void add({required String name, description, date, time}) {
    var uid = _uuid.v4();
    var todo = Todo(
      id: uid,
      name: name,
      description: description ?? "",
      date: date ?? "",
      time: time ?? "",
    );
    _todoBox.put(uid, todo);
    state = [
      ...state,
      todo,
    ];
  }

  void toggle(String id) {
    var todoList = [];
    var updatedTodo;
    for (final todo in state) {
      if (todo.id == id) {
        updatedTodo = Todo(
          id: todo.id,
          completed: !todo.completed,
          name: todo.name,
          description: todo.description,
          date: todo.date,
          time: todo.time,
        );
        todoList.add(updatedTodo);
      } else {
        todoList.add(todo);
      }
    }
    _todoBox.put(updatedTodo.id, updatedTodo);
    state = [...todoList];
  }

  void edit({
    required String id,
    name,
    description,
    date,
    time,
  }) {
    var todoList = [];
    var updatedTodo;
    for (final todo in state) {
      if (todo.id == id) {
        updatedTodo = Todo(
          id: todo.id,
          completed: todo.completed,
          name: name ?? todo.name,
          description: description ?? todo.description,
          date: date ?? todo.date,
          time: time ?? todo.time,
        );
        todoList.add(updatedTodo);
      } else {
        todoList.add(todo);
      }
    }
    _todoBox.put(updatedTodo.id, updatedTodo);
    state = [...todoList];
  }

  void remove(Todo target) {
    _todoBox.delete(target.id);
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
