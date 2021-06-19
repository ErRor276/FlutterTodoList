import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';

class TodoDialog extends StatelessWidget {
  const TodoDialog({Key? key, required this.todo}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    var seperator = todo.date.isEmpty || todo.time.isEmpty ? "" : ", ";
    var datetimeString = todo.date + seperator + todo.time;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black45, offset: Offset(0, 4), blurRadius: 4),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              todo.name,
              softWrap: true,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                datetimeString,
                softWrap: true,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            SizedBox(height: 16),
            Text(
              todo.description,
              softWrap: true,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
