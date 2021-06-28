import 'package:flutter/material.dart';
import 'package:todo_list/models/layout.dart';

class Header extends StatelessWidget {
  const Header({Key? key, required this.header, required this.layoutData})
      : super(key: key);

  final String header;
  final Layout layoutData;

  @override
  Widget build(BuildContext context) {
    return Text(
      header,
      style: layoutData.headline1,
    );
  }
}
