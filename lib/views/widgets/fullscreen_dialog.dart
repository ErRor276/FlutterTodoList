import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todo_list/models/layout.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/utils/responsive.dart';

enum DialogType { add, edit }

class FullScreenDialog extends HookWidget {
  const FullScreenDialog({
    Key? key,
    required this.type,
    this.todo,
    required this.layoutData,
    required this.isSmallMobile,
  }) : super(key: key);

  final DialogType type;
  final Todo? todo;
  final Layout layoutData;
  final bool isSmallMobile;

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

    var formBody = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              child: Icon(
                Icons.close,
                color: Colors.black54,
                size: (layoutData.padding2 * 2) + (layoutData.padding1 / 4),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(
              child: Text(
                type == DialogType.add ? "Add Todo" : "Edit Todo",
                textAlign: TextAlign.center,
                style: layoutData.headline2,
              ),
            ),
            SizedBox(width: layoutData.padding1 * 4),
          ],
        ),
        Material(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(layoutData.padding2 * 2),
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
                errorText: !validated.value ? 'Name Can\'t Be Empty' : null,
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
            padding: EdgeInsets.symmetric(horizontal: layoutData.padding2 * 2),
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
          padding: EdgeInsets.symmetric(horizontal: layoutData.padding2 * 2),
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
                  width: layoutData.padding2 * 9,
                  padding: EdgeInsets.all(layoutData.padding1 / 4),
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
                          style: layoutData.bodyText2.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
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
              SizedBox(width: layoutData.padding1 * 2),
              Expanded(
                child: Text(
                  pickedDate.value,
                  style: layoutData.bodyText1.copyWith(
                    decoration: TextDecoration.none,
                    color: Color(0xFF212121),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: layoutData.padding1 * 2),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: layoutData.padding2 * 2),
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
                  width: layoutData.padding2 * 9,
                  padding: EdgeInsets.all(layoutData.padding1 / 4),
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
                          style: layoutData.bodyText2.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
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
              SizedBox(width: layoutData.padding1 * 2),
              Expanded(
                child: Text(
                  pickedTime.value,
                  style: layoutData.bodyText1.copyWith(
                    decoration: TextDecoration.none,
                    color: Color(0xFF212121),
                  ),
                ),
              ),
            ],
          ),
        ),
        isSmallMobile
            ? SizedBox(height: layoutData.padding1 * 2)
            : Expanded(child: SizedBox()),
        TextButton(
          onPressed: () async {
            nameController.text.isEmpty
                ? validated.value = false
                : validated.value = true;
            var date = pickedDate.value;
            var time = pickedTime.value;
            if (validated.value) {
              if (type == DialogType.add) {
                context
                    .read(todoListProvider.notifier)
                    .add(
                      name: nameController.text,
                      description: descController.text,
                      date: date,
                      time: time,
                    )
                    .then((value) => Navigator.of(context).pop());
              } else {
                await context
                    .read(todoListProvider.notifier)
                    .edit(
                      id: todo!.id,
                      name: nameController.text,
                      description: descController.text,
                      date: date,
                      time: time,
                    )
                    .then((value) => Navigator.of(context).pop());
              }
            }
          },
          child: Container(
            width: layoutData.padding1 * 10,
            height: (layoutData.padding2 * 2) + (layoutData.padding1 / 4),
            padding: EdgeInsets.all(layoutData.padding1 / 4),
            child: Center(
              child: Text(
                "Save",
                textAlign: TextAlign.center,
                style: layoutData.bodyText1.copyWith(
                  decoration: TextDecoration.none,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Theme.of(context).accentColor,
            ),
            elevation: MaterialStateProperty.all(1.0),
          ),
        ),
        SizedBox(height: layoutData.padding1),
      ],
    );

    useEffect(() {
      nameController.text = todo?.name ?? "";
      descController.text = todo?.description ?? "";
      pickedDate.value = todo?.date ?? "";
      pickedTime.value = todo?.time ?? "";
    }, const []);

    var allPadding = 8.0; // 4 before
    var topPadding = MediaQuery.of(context).viewPadding.top;
    var botPadding = MediaQuery.of(context).viewPadding.bottom;
    var padding = EdgeInsets.fromLTRB(
      allPadding,
      allPadding + topPadding + topPaddingSubtract(topPadding),
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
          child: isSmallMobile
              ? SingleChildScrollView(
                  child: formBody,
                )
              : formBody,
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
    var minString = min < 10 ? "0$min" : min;
    timeString += ":$minString";

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
