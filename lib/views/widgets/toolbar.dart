import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/models/layout.dart';
import 'package:todo_list/providers/todo_provider.dart';

class Toolbar extends HookWidget {
  const Toolbar({Key? key, required this.layoutData}) : super(key: key);

  final Layout layoutData;

  @override
  Widget build(BuildContext context) {
    final filter = useProvider(filterProvider);

    Color? textColorFor(Filter value) {
      return filter.state == value
          ? Theme.of(context).accentColor
          : Colors.black45;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            '${useProvider(activeTodosCount).toString()} active items',
            style: layoutData.bodyText2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Tooltip(
          message: 'All todos',
          // ignore: deprecated_member_use, TextButton is not available in stable yet
          child: FlatButton(
            onPressed: () => filter.state = Filter.all,
            visualDensity: VisualDensity.compact,
            textColor: textColorFor(Filter.all),
            child: const Text('All'),
          ),
        ),
        Tooltip(
          message: 'Only uncompleted todos',
          // ignore: deprecated_member_use, TextButton is not available in stable yet
          child: FlatButton(
            onPressed: () => filter.state = Filter.active,
            visualDensity: VisualDensity.compact,
            textColor: textColorFor(Filter.active),
            child: const Text('Active'),
          ),
        ),
        Tooltip(
          message: 'Only completed todos',
          // ignore: deprecated_member_use, TextButton is not available in stable yet
          child: FlatButton(
            onPressed: () => filter.state = Filter.completed,
            visualDensity: VisualDensity.compact,
            textColor: textColorFor(Filter.completed),
            child: const Text('Completed'),
          ),
        ),
      ],
    );
  }
}
