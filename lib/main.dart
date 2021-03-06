import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
        fontFamily: 'Roboto',
      ),
      home: (dbInit && notiInit)
          ? HomePage()
          : Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
