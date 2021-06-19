import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum DialogType { add, edit }

class FullScreenDialog extends HookWidget {
  const FullScreenDialog({
    Key? key,
    required this.type,
    this.todo,
  }) : super(key: key);

  final DialogType type;
  final Todo? todo;

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final nameFocusNode = useFocusNode();
    useListenable(nameFocusNode);
    final nameIsFocused = nameFocusNode.hasFocus;

    final descController = useTextEditingController();
    final descFocusNode = useFocusNode();
    useListenable(descFocusNode);
    final descIsFocused = descFocusNode.hasFocus;

    final pickedDate = useState("");
    final pickedTime = useState("");
    final validated = useState(true);

    useEffect(() {
      nameController.text = todo?.name ?? "";
      descController.text = todo?.description ?? "";
      pickedDate.value = todo?.date ?? "";
      pickedTime.value = todo?.time ?? "";
    }, const []);

    var allPadding = 4.0;
    var topPadding = MediaQuery.of(context).viewPadding.top;
    var botPadding = MediaQuery.of(context).viewPadding.bottom;
    var padding = EdgeInsets.fromLTRB(
      allPadding,
      allPadding + topPadding,
      allPadding,
      allPadding + botPadding,
    );

    return Center(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: padding,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Icon(
                      Icons.close,
                      color: Colors.black54,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(
                    child: Text(
                      type == DialogType.add ? "Add Todo" : "Edit Todo",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  SizedBox(width: 64),
                ],
              ),
              Material(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: TextField(
                    focusNode: nameFocusNode,
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        color: nameIsFocused
                            ? Theme.of(context).accentColor
                            : Colors.black45,
                      ),
                      errorText:
                          !validated.value ? 'Name Can\'t Be Empty' : null,
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    cursorColor: Theme.of(context).accentColor,
                    onSubmitted: (value) {
                      nameFocusNode.unfocus();
                    },
                  ),
                ),
              ),
              Material(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    focusNode: descFocusNode,
                    controller: descController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(
                        color: descIsFocused
                            ? Theme.of(context).accentColor
                            : Colors.black45,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    cursorColor: Theme.of(context).accentColor,
                    onSubmitted: (value) {
                      descFocusNode.unfocus();
                    },
                  ),
                ),
              ),
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          onChanged: (date) {
                            print('change $date');
                          },
                          onConfirm: (date) {
                            pickedDate.value = dateFormatter(date);
                            print('confirm $pickedDate');
                          },
                          currentTime: DateTime.now(),
                          locale: LocaleType.en,
                        );
                      },
                      child: Container(
                        width: 100,
                        padding: EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.date_range,
                              color: Colors.white,
                            ),
                            Expanded(
                              child: Text(
                                "Pick Date",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xFF757575),
                        ),
                        elevation: MaterialStateProperty.all(1.0),
                      ),
                    ),
                    SizedBox(width: 32),
                    Expanded(
                      child: Text(
                        pickedDate.value,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        DatePicker.showTimePicker(
                          context,
                          showTitleActions: true,
                          showSecondsColumn: false,
                          onChanged: (date) {
                            print('change $date');
                          },
                          onConfirm: (date) {
                            print('confirm $date');
                            pickedTime.value = timeFormatter(date);
                          },
                          currentTime: DateTime.now(),
                          locale: LocaleType.en,
                        );
                      },
                      child: Container(
                        width: 100,
                        padding: EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer,
                              color: Colors.white,
                            ),
                            Expanded(
                              child: Text(
                                "Pick Time",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xFF757575),
                        ),
                        elevation: MaterialStateProperty.all(1.0),
                      ),
                    ),
                    SizedBox(width: 32),
                    Expanded(
                      child: Text(
                        pickedTime.value,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: SizedBox()),
              TextButton(
                onPressed: () {
                  nameController.text.isEmpty
                      ? validated.value = false
                      : validated.value = true;
                  var date = pickedDate.value;
                  var time = pickedTime.value;
                  if (validated.value) {
                    if (type == DialogType.add) {
                      context.read(todoListProvider.notifier).add(
                            name: nameController.text,
                            description: descController.text,
                            date: date,
                            time: time,
                          );
                    } else {
                      context.read(todoListProvider.notifier).edit(
                            id: todo!.id,
                            name: nameController.text,
                            description: descController.text,
                            date: date,
                            time: time,
                          );
                    }

                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                  width: 160,
                  padding: EdgeInsets.all(4),
                  child: Text(
                    "Save",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).accentColor,
                  ),
                  elevation: MaterialStateProperty.all(1.0),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String dateFormatter(DateTime date) {
    var dateString = "";
    var day = date.day;
    var month = date.month;
    var year = date.year;

    // adding day
    dateString += day.toString();

    // adding suffix
    if (day == 1) {
      dateString += "st";
    } else if (day == 2) {
      dateString += "nd";
    } else {
      dateString += "th";
    }

    // adding month name
    dateString += " " + monthName(month);

    // adding year
    if (year != DateTime.now().year) {
      dateString += " " + year.toString();
    }

    return dateString;
  }

  String timeFormatter(DateTime time) {
    var timeString = "";
    var hour = time.hour;
    var min = time.minute;

    // adding 12-format hour
    timeString += (hour % 12).toString();

    // adding minute
    timeString += ":$min";

    // adding suffix
    if ((hour / 12).floor() == 1) {
      timeString += " pm";
    } else {
      timeString += " am";
    }

    return timeString;
  }

  String monthName(month) {
    switch (month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
      default:
        return "Dec";
    }
  }
}
