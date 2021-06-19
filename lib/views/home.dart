import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todo_list/state.dart';
import 'package:todo_list/views/widgets/fullscreen_dialog.dart';
import 'package:todo_list/views/widgets/searchbar.dart';
import 'package:todo_list/views/widgets/todo_listview.dart';
import 'package:todo_list/views/widgets/toolbar.dart';
import 'widgets/header.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('building MyHomePage');
    context.read(todoListProvider.notifier).init();
    var allPadding = 20.0;
    var topPadding = MediaQuery.of(context).viewPadding.top;
    var botPadding = MediaQuery.of(context).viewPadding.bottom;
    var padding = EdgeInsets.fromLTRB(
      allPadding,
      allPadding + topPadding,
      allPadding,
      allPadding + botPadding,
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(header: "Todo List"),
              SizedBox(height: 12),
              Searchbar(),
              Toolbar(),
              SizedBox(height: 6),
              Expanded(
                child: TodoListView(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Add Todo',
            onPressed: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel:
                    MaterialLocalizations.of(context).modalBarrierDismissLabel,
                barrierColor: Colors.black45,
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (BuildContext buildContext, Animation animation,
                    Animation secondaryAnimation) {
                  return FullScreenDialog(
                    type: DialogType.add,
                  );
                },
              );
            }),
      ),
    );
  }
}
