import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/material.dart';

import 'emoji_text.dart';

class TextSpanBuilder extends SpecialTextSpanBuilder {
  final bool showAtBackground;

  TextSpanBuilder({
    this.showAtBackground = false,
  });

  @override
  TextSpan build(String data,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap}) {
    final TextSpan result =
        super.build(data, textStyle: textStyle, onTap: onTap);
    return result;
  }

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      int? index}) {
    if (flag.isEmpty) {
      return null;
    }

    if (isStart(flag, EmojiText.flag)) {
      return EmojiText(textStyle!, start: index! - (EmojiText.flag.length - 1));
    }
    return null;
  }
}

class SpecialTextStyle {
  TextRange? textRange;
}
