import 'package:example/special_text/image_text.dart';
import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/material.dart';

import 'at_text.dart';
import 'dollar_text.dart';
import 'emoji_text.dart';

class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  MySpecialTextSpanBuilder({this.showAtBackground = false});

  /// whether show background for @somebody
  final bool showAtBackground;

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      int? index}) {
    if (flag == '') {
      return null;
    }

    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    if (isStart(flag, EmojiText.flag)) {
      return EmojiText(textStyle, start: index! - (EmojiText.flag.length - 1));
    } else if (isStart(flag, ImageText.flag)) {
      return ImageText(textStyle,
          start: index! - (ImageText.flag.length - 1), onTap: onTap);
    } else if (isStart(flag, AtText.flag)) {
      return AtText(
        textStyle,
        onTap,
        start: index! - (AtText.flag.length - 1),
        showAtBackground: showAtBackground,
      );
    } else if (isStart(flag, EmojiText.flag)) {
      return EmojiText(textStyle, start: index! - (EmojiText.flag.length - 1));
    } else if (isStart(flag, DollarText.flag)) {
      return DollarText(textStyle, onTap,
          start: index! - (DollarText.flag.length - 1));
    }
    return null;
  }
}
