import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/models/layout.dart';
import 'package:todo_list/providers/responsive_provider.dart';

import 'models/todo.dart';
import 'providers/todo_provider.dart';

final todoListProvider = StateNotifierProvider<TodoListNotifier, List<Todo>>(
  (ref) => TodoListNotifier(),
);

final responsiveProvider = StateNotifierProvider<ResponsiveNotifier, Layout>(
  (ref) => ResponsiveNotifier(
    Layout(
      headline1: TextStyle(
        decoration: TextDecoration.none,
        color: Color(0xFF212121),
        fontWeight: FontWeight.w400,
        fontSize: 34,
        letterSpacing: 0.25,
      ),
      headline2: TextStyle(
        decoration: TextDecoration.none,
        color: Color(0xFF212121),
        fontWeight: FontWeight.w400,
        fontSize: 24,
        letterSpacing: 0,
      ),
      headline3: TextStyle(
        decoration: TextDecoration.none,
        color: Color(0xFF212121),
        fontWeight: FontWeight.w500,
        fontSize: 20,
        letterSpacing: 0.15,
      ),
      bodyText1: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        letterSpacing: 0.5,
      ),
      bodyText2: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 14,
        letterSpacing: 0.25,
      ),
    ),
  ),
);
