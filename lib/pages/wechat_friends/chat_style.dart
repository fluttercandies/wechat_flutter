import 'package:flutter/material.dart';

var backgroundImage =
    'https://hbimg.huabanimg.com/907605885b6dac544640128d8f5c6b089de96519117bb5-VdbptL';

class Line extends StatelessWidget {
  final Color color;
  final EdgeInsetsGeometry margin;
  final double lineHeight;

  Line({Key key, this.color, this.margin, this.lineHeight: 0.2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: lineHeight,
        color: color ?? Colors.white,
        margin: margin ?? EdgeInsets.only(top: 10.0, bottom: 10.0));
  }
}

class TextStyles {
  static TextStyle textStyle(
      {double fontSize: Dimens.font_sp12,
        Color color: Colors.white,
        FontWeight fontWeight}) {
    return TextStyle(
        fontSize: fontSize,
        color: color,
        decoration: TextDecoration.none,
        fontWeight: fontWeight);
  }

  static TextStyle textWhite14 = textStyle(fontSize: Dimens.font_sp14);
  static TextStyle textRed14 =
  textStyle(fontSize: Dimens.font_sp14, color: Colors.red);

  static TextStyle textGrey14 =
  textStyle(fontSize: Dimens.font_sp14, color: Colors.grey);
  static TextStyle textDark14 =
  textStyle(fontSize: Dimens.font_sp14, color: grey3Color);
  static TextStyle textBoldDark14 = textStyle(
      fontSize: Dimens.font_sp14,
      color: Colors.black,
      fontWeight: FontWeight.bold);
  static TextStyle textBoldWhile14 =
  textStyle(fontSize: Dimens.font_sp14, fontWeight: FontWeight.bold);
  static TextStyle textBoldBlue14 = textStyle(
      fontSize: Dimens.font_sp14,
      fontWeight: FontWeight.bold,
      color: Colors.blueAccent);

  static TextStyle textReader16 =
  textStyle(fontSize: Dimens.font_sp16, color: readerMainColor);
  static TextStyle textRed16 =
  textStyle(fontSize: Dimens.font_sp16, color: Colors.red);
  static TextStyle textBlue16 =
  textStyle(fontSize: Dimens.font_sp16, color: Colors.blueAccent);
  static TextStyle textWhite16 = textStyle(fontSize: Dimens.font_sp16);
  static TextStyle textGreyC16 =
  textStyle(fontSize: Dimens.font_sp16, color: greyCColor);
  static TextStyle textGrey16 =
  textStyle(fontSize: Dimens.font_sp16, color: Colors.grey);
  static TextStyle textDark16 =
  textStyle(fontSize: Dimens.font_sp16, color: grey3Color);
}

class Dimens {
  static const double font_sp10 = 10;
  static const double font_sp12 = 12;
  static const double font_sp14 = 14;
  static const double font_sp16 = 16;
  static const double font_sp18 = 18;
  static const double font_sp20 = 20;
  static const double font_sp26 = 26;
  static const double font_sp40 = 40;

  static const double gap_dp3 = 3;
  static const double gap_dp4 = 4;
  static const double gap_dp5 = 5;
  static const double gap_dp6 = 6;
  static const double gap_dp8 = 8;
  static const double gap_dp10 = 10;
  static const double gap_dp12 = 12;
  static const double gap_dp15 = 15;
  static const double gap_dp16 = 16;
  static const double gap_dp20 = 20;
  static const double gap_dp24 = 24;
  static const double gap_dp25 = 25;
  static const double gap_dp40 = 40;
  static const double gap_dp48 = 48;
  static const double gap_dp60 = 60;

  static const double line_dp2 = 2;
  static const double line_dp1 = 1;
  static const double line_dp_half = 0.5;

  static const double homeImageSize = 27.0;

  static const double maxFontSize = 30.0;
  static const double minFontSize = 10.0;

  static const double minSpace = 1.0;
  static const double maxSpace = 3.0;

  static const double chapterItemHeight = 50.0;
}

const Color accentColor = const Color(0xFFF08F8F);
const Color lightAccentColor = const Color(0xFFFfaFaF);
const Color darkAccentColor = const Color(0xFFd06F6F);

const Color readerMainColor = const Color(0xFF33C3A5);
const Color readerMainDisColor = const Color(0xFFE0FFFF);

const Color colorGreyA = const Color(0xFFAAAAAA);

const Color colorNavajoWhite = const Color(0xFFFFDEAD);
const Color colorPapayaWhip = const Color(0xFFFFEFD5);
const Color colorPeachPuff = const Color(0xFFFFDAB9);
const Color colorMoccasin = const Color(0xFFFFE4B5);
const Color colorLemonChiffon = const Color(0xFFFFFACD);
const Color colorHoneydew = const Color(0xFFF0FFF0);
const Color colorMintCream = const Color(0xFFF5FFFA);
const Color colorMistyRose = const Color(0xFFFFE4E1);
const Color colorLightBlue2 = const Color(0xFFB2DFEE);
const Color colorLightCyan1 = const Color(0xFFE0FFFF);
const Color colorPink1 = const Color(0xFFFFB5C5);

const Color colorDarkGoldenrod3 = const Color(0xFFCD950C);

const Color colorSnow = const Color(0xFFFFFAFA);

const Color starColor = const Color(0xFFFACE41);

const Color greyCColor = const Color(0xFFCCCCCC);
const Color grey3Color = const Color(0xFF333333);
const Color grey6Color = const Color(0xFF666666);
const Color grey9Color = const Color(0xFF999999);

const Color qdailyMajorColor = const Color(0xFFFFD003);
const Color qdailyMinorColor = const Color(0xFFFFE48E);

