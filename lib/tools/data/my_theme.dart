import 'package:flutter/material.dart';

class MyTheme {
  static MaterialColor themeColor() {
    final _colorValue = Colors.green.value;
    final _colorEntity = Color(_colorValue);
    MaterialColor themeColor = MaterialColor(
      _colorValue,
      <int, Color>{
        50: _colorEntity,
        100: _colorEntity,
        200: _colorEntity.withOpacity(0.2),
        300: _colorEntity.withOpacity(0.3),
        400: _colorEntity.withOpacity(0.4),
        500: _colorEntity.withOpacity(0.5),
        600: _colorEntity,
        700: _colorEntity,
        800: _colorEntity,
        900: _colorEntity,
      },
    );
    return themeColor;
  }

  static appBarMainColor() {
    // if (!Q1Data.isDark()) {
    //   return Colors.white;
    // }
    return Colors.black;
  }

  static double susItemHeight() => 40;

  static Decoration getIndexBarDecoration(Color color) {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey[300], width: .5));
  }

  static Color mainLineColor() {
    // if (!Q1Data.isDark()) {
    //   return Colors.grey.withOpacity(0.1);
    // }
    return const Color(0xfff1f0f1);
  }

  static TextStyle mapLabelStyle([Color color]) {
    return TextStyle(
      color: color ?? Colors.black,
      fontSize: 15,
      fontWeight: MyTheme.fontWeight(),
    );
  }

  /// 常用item标题样式
  static TextStyle itemTitleStyle([Color color]) {
    return TextStyle(
      color: Colors.black.withOpacity(0.7),
      fontSize: 15,
      fontWeight: MyTheme.fontWeight(),
    );
  }

  static TextStyle hintLabel1([Color color]) {
    return TextStyle(
      color: color ?? Colors.grey,
      fontSize: 12,
      fontWeight: MyTheme.fontWeight(),
    );
  }

  static TextStyle hintLabel2([Color color]) {
    return TextStyle(
      color: color ?? Colors.grey,
      fontSize: 10,
      fontWeight: MyTheme.fontWeight(),
    );
  }

  static FontWeight fontWeight() {
    return FontWeight.w300;
  }

  static Color get btBackgroundColor {
    return Color(0xfff0f0f0);
  }

  static Color fieldBorderColor() {
    return Colors.grey.withOpacity(0.2);
  }

  static Color selectLabelColor() {
    return MyTheme.themeColor().withOpacity(0.8);
  }

  static Border mainBorder([Color color]) {
    return Border(bottom: mainBorderSide(color));
  }

  static mainBorderSide([Color color]) {
    return BorderSide(color: color ?? Color(0xffEFEFEF), width: 1);
  }
}

class MyStyle {
  static TextStyle hitLabelStyle = TextStyle(
      color: Colors.white, fontSize: 9, fontWeight: FontWeight.w300);

  static TextStyle hitLabelStyleBlack1 = TextStyle(
      color: Colors.black, fontSize: 9, fontWeight: FontWeight.w300);

  static TextStyle hitLabelStyleBlack = TextStyle(
      color: Colors.black, fontSize: 13, fontWeight: FontWeight.w300);
}
