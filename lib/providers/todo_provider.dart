import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/database.dart';
import 'package:todo_list/services/notification_service.dart';
import 'package:todo_list/state.dart';
import 'package:timezone/timezone.dart' as tz;

var _todoBox;

/// An object that controls a list of [Todo].
class TodoListNotifier extends StateNotifier<List<Todo>> {
  TodoListNotifier() : super([]) {
    init();
  }

  void init() async {
    // if (!initiated) {
    //   initiated = true;
    //   print("in init");
    //   await Hive.initFlutter();
    //   print("after call");
    //   Hive.registerAdapter<Todo>(TodoAdapter());
    //   await Hive.openBox<Todo>(todoBox).then((value) {
    //     print("db called");
    //     _todoBox = value;
    //     List<Todo> todos = _todoBox.values.toList();
    //     state = [...todos];
    //   });
    // }
    Database().getBox().then((value) {
      _todoBox = value;
      List<Todo> todos = _todoBox.values.toList();
      state = [...todos];
    });
  }

  Future add({required String name, description, date, time}) async {
    var descriptionTmp = description ?? "";
    var dateTmp = date ?? "";
    var timeTmp = time ?? "";
    var todo = Todo(
      id: "0",
      name: name,
      description: descriptionTmp,
      date: dateTmp,
      time: timeTmp,
    );
    _todoBox.add(todo).then((key) {
      var todo = Todo(
        id: "$key",
        name: name,
        description: descriptionTmp,
        date: dateTmp,
        time: timeTmp,
      );
      _todoBox.put(key, todo);
      if (dateTmp != "" && timeTmp != "") {
        scheduleNotification(
            key: key, title: name, date: dateTmp, time: timeTmp);
      }
      state = [
        ...state,
        todo,
      ];
    });
  }

  Future toggle(String id) async {
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
    _todoBox.put(int.parse(updatedTodo.id), updatedTodo);
    if (updatedTodo.date != "" &&
        updatedTodo.time != "" &&
        !updatedTodo.completed) {
      await scheduleNotification(
        key: int.parse(updatedTodo.id),
        title: updatedTodo.name,
        date: updatedTodo.date,
        time: updatedTodo.time,
      );
    } else if (updatedTodo.date != "" &&
        updatedTodo.time != "" &&
        updatedTodo.completed) {
      await NotificationService().cancelNotification(int.parse(updatedTodo.id));
    }
    state = [...todoList];
  }

  Future edit({
    required String id,
    name,
    description,
    date,
    time,
  }) async {
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
    _todoBox.put(int.parse(updatedTodo.id), updatedTodo);
    if (updatedTodo.date != "" && updatedTodo.time != "") {
      await scheduleNotification(
        key: int.parse(updatedTodo.id),
        title: updatedTodo.name,
        date: updatedTodo.date,
        time: updatedTodo.time,
      );
    } else {
      await NotificationService().cancelNotification(int.parse(updatedTodo.id));
    }
    state = [...todoList];
  }

  Future remove(Todo target) async {
    if (target.date != "" && target.time != "") {
      await NotificationService().cancelNotification(int.parse(target.id));
    }
    _todoBox.delete(int.parse(target.id));
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

Future<void> scheduleNotification({
  required int key,
  required String title,
  required String date,
  required String time,
}) async {
  var now = tz.TZDateTime.now(tz.local);
  var scheduled = schedule(date, time, now);
  if (now.compareTo(scheduled) < 0) {
    await NotificationService().scheduleNotification(
      id: key,
      title: title,
      body: "Time to do $title",
      scheduledDatetime: scheduled,
    );
  }
}

dynamic schedule(String date, String time, dynamic now) {
  var dateAry = date.split(" ");
  var timeAry = time.split(" ");
  var timeNumAry = timeAry[0].split(":");
  var timeZone = timeAry[1];

  var year = dateAry.length > 2 ? dateAry[2] : now.year;
  var month = monthToNum(dateAry[1]);
  var day = dateAry[0].substring(0, dateAry[0].length - 2);
  var hour = int.parse(timeNumAry[0]);
  hour += timeZone == "pm" ? 12 : 0;
  var hourStr = hour < 10 ? "0$hour" : hour;
  var min = timeNumAry[1];

  var scheduled =
      tz.TZDateTime.parse(tz.local, "$year-$month-$day $hourStr:$min:00");
  return scheduled;
}

String monthToNum(String month) {
  switch (month) {
    case "Jan":
      return "01";
    case "Feb":
      return "02";
    case "Mar":
      return "03";
    case "April":
      return "04";
    case "May":
      return "05";
    case "Jun":
      return "06";
    case "Jul":
      return "07";
    case "Aug":
      return "08";
    case "Sep":
      return "09";
    case "Oct":
      return "10";
    case "Nov":
      return "11";
    case "Dec":
    default:
      return "12";
  }
}
