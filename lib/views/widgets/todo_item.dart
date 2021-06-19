import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TodoItem extends HookWidget {
  const TodoItem({Key? key, required this.todo}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    var seperator = todo.date.isEmpty || todo.time.isEmpty ? "" : ", ";
    var datetimeString = todo.date + seperator + todo.time;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: todo.completed,
                  onChanged: (value) =>
                      context.read(todoListProvider.notifier).toggle(todo.id),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          todo.name,
                          style: Theme.of(context).textTheme.bodyText1,
                          softWrap: true,
                        ),
                      ),
                      Text(
                        datetimeString,
                        style: Theme.of(context).textTheme.bodyText2,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
