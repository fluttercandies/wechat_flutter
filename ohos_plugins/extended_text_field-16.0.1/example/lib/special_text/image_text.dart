import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:html/dom.dart' hide Text;
import 'package:html/parser.dart';

class ImageText extends SpecialText {
  ImageText(TextStyle? textStyle,
      {this.start, SpecialTextGestureTapCallback? onTap})
      : super(
          ImageText.flag,
          '/>',
          textStyle,
          onTap: onTap,
        );

  static const String flag = '<img';
  final int? start;
  String? _imageUrl;
  String? get imageUrl => _imageUrl;
  @override
  InlineSpan finishText() {
    ///content already has endflag '/'
    final String text = toString();

    ///'<img src='$url'/>'
//    var index1 = text.indexOf(''') + 1;
//    var index2 = text.indexOf(''', index1);
//
//    var url = text.substring(index1, index2);
//
    ////'<img src='$url' width='${item.imageSize.width}' height='${item.imageSize.height}'/>'
    final Document html = parse(text);

    final Element img = html.getElementsByTagName('img').first;
    final String url = img.attributes['src']!;
    _imageUrl = url;

    //fontsize id define image height
    //size = 30.0/26.0 * fontSize
    double? width = 60.0;
    double? height = 60.0;
    const BoxFit fit = BoxFit.cover;
    const double num300 = 60.0;
    const double num400 = 80.0;

    height = num300;
    width = num400;
    const bool knowImageSize = true;
    if (knowImageSize) {
      height = double.tryParse(img.attributes['height']!);
      width = double.tryParse(img.attributes['width']!);
      final double n = height! / width!;
      if (n >= 4 / 3) {
        width = num300;
        height = num400;
      } else if (4 / 3 > n && n > 3 / 4) {
        final double maxValue = max(width, height);
        height = num400 * height / maxValue;
        width = num400 * width / maxValue;
      } else if (n <= 3 / 4) {
        width = num400;
        height = num300;
      }
    }

    ///fontSize 26 and text height =30.0
    //final double fontSize = 26.0;

    return ExtendedWidgetSpan(
      start: start!,
      actualText: text,
      child: GestureDetector(
        onTap: () {
          onTap?.call(url);
        },
        child: ExtendedImage.network(
          url,
          width: width,
          height: height,
          fit: fit,
        ),
      ),
    );
  }
}
