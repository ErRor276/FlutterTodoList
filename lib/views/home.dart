import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todo_list/models/layout.dart';
import 'package:todo_list/state.dart';
import 'package:todo_list/utils/responsive.dart';
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // var layout = useProvider(responsiveProvider);
    // context
    //     .read(responsiveProvider.notifier)
    //     .size(height: height, width: width);
    print("height: $height width: $width");
    var layout = getLayout(width: width);
    context.read(todoListProvider.notifier).init();
    var allPadding = 20.0;
    var topPadding = MediaQuery.of(context).viewPadding.top;
    var botPadding = MediaQuery.of(context).viewPadding.bottom;
    print("top padding: $topPadding");
    var padding = EdgeInsets.fromLTRB(
      allPadding,
      allPadding + topPadding + topPaddingSubtract(topPadding),
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
              Header(header: "Todo List", layoutData: layout),
              SizedBox(height: layout.padding2),
              Searchbar(layoutData: layout),
              Toolbar(
                layoutData: layout,
                isSmallMobile: width <= 380,
              ),
              SizedBox(height: layout.padding2 / 2),
              Expanded(
                child: TodoListView(
                  layoutData: layout,
                  isSmallMobile: height < 640,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.add,
              size: (layout.padding2 * 2) + (layout.padding1 / 4),
            ),
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
                    layoutData: layout,
                    isSmallMobile: height < 640,
                  );
                },
              );
            }),
      ),
    );
  }
}
