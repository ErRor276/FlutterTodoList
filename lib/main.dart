import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/services/database.dart';
import 'package:todo_list/services/notification_service.dart';

import 'views/home.dart';

var dbInit = false;
var notiInit = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dbInit = await Database().init();
  print("dbInit: $dbInit");
  notiInit = await NotificationService().init();
  print("notiInit: $notiInit");

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF3185FC),
        accentColor: Color(0xFFDA3E52),
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          bodyText2: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
      ),
      home: (dbInit && notiInit)
          ? HomePage()
          : Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
