import 'package:flutter/material.dart';
import 'package:todo_list/models/layout.dart';

Layout getLayout({required double width}) {
  var defaultLayout = Layout(
    headline1: TextStyle(
      fontFamily: 'Roboto',
      decoration: TextDecoration.none,
      color: Color(0xFF212121),
      fontWeight: FontWeight.w400,
      fontSize: 34,
      letterSpacing: 0.25,
    ),
    headline2: TextStyle(
      fontFamily: 'Roboto',
      decoration: TextDecoration.none,
      color: Color(0xFF212121),
      fontWeight: FontWeight.w400,
      fontSize: 24,
      letterSpacing: 0,
    ),
    headline3: TextStyle(
      fontFamily: 'Roboto',
      decoration: TextDecoration.none,
      color: Color(0xFF212121),
      fontWeight: FontWeight.w500,
      fontSize: 20,
      letterSpacing: 0.15,
    ),
    bodyText1: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      fontSize: 16,
      letterSpacing: 0.5,
    ),
    bodyText2: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w300,
      fontSize: 14,
      letterSpacing: 0.25,
    ),
    padding1: 16.0,
    padding2: 12.0,
  );
  // width <= 380 small phone
  // 380 < width < 480 medium phone
  // 480 <= width < 768 medium tablet
  // 768 <= width large tablet
  if (width <= 380.0) {
    return Layout(
      headline1: defaultLayout.headline1.copyWith(fontSize: 34),
      headline2: defaultLayout.headline2.copyWith(fontSize: 24),
      headline3: defaultLayout.headline3.copyWith(fontSize: 20),
      bodyText1: defaultLayout.bodyText1.copyWith(fontSize: 16),
      bodyText2: defaultLayout.bodyText2.copyWith(fontSize: 14),
      padding1: 16.0,
      padding2: 12.0,
    );
  } else if (width > 380.0 && width < 480.0) {
    return Layout(
      headline1: defaultLayout.headline1.copyWith(fontSize: 34),
      headline2: defaultLayout.headline2.copyWith(fontSize: 24),
      headline3: defaultLayout.headline3.copyWith(fontSize: 20),
      bodyText1: defaultLayout.bodyText1.copyWith(fontSize: 16),
      bodyText2: defaultLayout.bodyText2.copyWith(fontSize: 14),
      padding1: 16.0,
      padding2: 12.0,
    );
  } else if (width >= 480.0 && width < 768.0) {
    return Layout(
      headline1: defaultLayout.headline1.copyWith(fontSize: 42),
      headline2: defaultLayout.headline2.copyWith(fontSize: 30),
      headline3: defaultLayout.headline3.copyWith(fontSize: 24),
      bodyText1: defaultLayout.bodyText1.copyWith(fontSize: 18),
      bodyText2: defaultLayout.bodyText2.copyWith(fontSize: 16),
      padding1: 20.0,
      padding2: 16.0,
    );
  } else {
    return Layout(
      headline1: defaultLayout.headline1.copyWith(fontSize: 42),
      headline2: defaultLayout.headline2.copyWith(fontSize: 30),
      headline3: defaultLayout.headline3.copyWith(fontSize: 24),
      bodyText1: defaultLayout.bodyText1.copyWith(fontSize: 18),
      bodyText2: defaultLayout.bodyText2.copyWith(fontSize: 16),
      padding1: 20.0,
      padding2: 16.0,
    );
  }
}

double topPaddingSubtract(double topPadding) {
  if (topPadding <= 24) {
    return -18.0;
  } else if (topPadding > 24 && topPadding < 40) {
    return -8.0;
  } else if (topPadding >= 44) {
    return -16.0;
  } else {
    return -1.0;
  }
}
