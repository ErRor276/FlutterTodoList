import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({Key? key, required this.header}) : super(key: key);

  final String header;

  @override
  Widget build(BuildContext context) {
    return Text(
      header,
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
