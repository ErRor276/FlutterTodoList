import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/models/layout.dart';
import 'package:todo_list/providers/todo_provider.dart';
import 'package:todo_list/state.dart';
import 'package:todo_list/views/widgets/fullscreen_dialog.dart';
import 'package:todo_list/views/widgets/todo_dialog.dart';

import 'todo_item.dart';

class TodoListView extends HookWidget {
  const TodoListView({Key? key, required this.layoutData}) : super(key: key);

  final Layout layoutData;

  @override
  Widget build(BuildContext context) {
    final todoList = useProvider(filteredTodoListProvider);
    return ListView(
      children: [
        for (var i = 0; i < todoList.length; i++) ...[
          if (i > 0)
            SizedBox(
              height: 16,
            ),
          Dismissible(
            key: ValueKey(todoList[i].id),
            onDismissed: (_) {
              context.read(todoListProvider.notifier).remove(todoList[i]);
            },
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TodoDialog(
                      todo: todoList[i],
                      layoutData: layoutData,
                    );
                  },
                );
              },
              onLongPress: () {
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: MaterialLocalizations.of(context)
                      .modalBarrierDismissLabel,
                  barrierColor: Colors.black45,
                  transitionDuration: const Duration(milliseconds: 200),
                  pageBuilder: (BuildContext buildContext, Animation animation,
                      Animation secondaryAnimation) {
                    return FullScreenDialog(
                      type: DialogType.edit,
                      todo: todoList[i],
                      layoutData: layoutData,
                    );
                  },
                );
              },
              child: TodoItem(
                todo: todoList[i],
                layoutData: layoutData,
              ),
            ),
          ),
        ],
        SizedBox(height: 32),
      ],
    );
  }
}
