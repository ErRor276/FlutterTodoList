import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/models/layout.dart';
import 'package:todo_list/providers/todo_provider.dart';

class Toolbar extends HookWidget {
  const Toolbar(
      {Key? key, required this.layoutData, required this.isSmallMobile})
      : super(key: key);

  final Layout layoutData;
  final bool isSmallMobile;

  @override
  Widget build(BuildContext context) {
    final filter = useProvider(filterProvider);

    Color? textColorFor(Filter value) {
      return filter.state == value
          ? Theme.of(context).accentColor
          : Colors.black45;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: isSmallMobile
                  ? SizedBox(
                      height: 0,
                      width: 0,
                    )
                  : Text(
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
                child: Text(
                  'All',
                  style: layoutData.bodyText2
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Tooltip(
              message: 'Only uncompleted todos',
              // ignore: deprecated_member_use, TextButton is not available in stable yet
              child: FlatButton(
                onPressed: () => filter.state = Filter.active,
                visualDensity: VisualDensity.compact,
                textColor: textColorFor(Filter.active),
                child: Text(
                  'Active',
                  style: layoutData.bodyText2
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Tooltip(
              message: 'Only completed todos',
              // ignore: deprecated_member_use, TextButton is not available in stable yet
              child: FlatButton(
                onPressed: () => filter.state = Filter.completed,
                visualDensity: VisualDensity.compact,
                textColor: textColorFor(Filter.completed),
                child: Text(
                  'Completed',
                  style: layoutData.bodyText2
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
        isSmallMobile
            ? Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '${useProvider(activeTodosCount).toString()} active items',
                  style: layoutData.bodyText2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            : SizedBox(
                height: 0,
                width: 0,
              ),
      ],
    );
  }
}
