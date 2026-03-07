import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/material.dart';

///emoji/image text
class EmojiText extends SpecialText {
  EmojiText(TextStyle? textStyle, {this.start})
      : super(EmojiText.flag, ']', textStyle);
  static const String flag = '[';
  final int? start;
  @override
  InlineSpan finishText() {
    final String key = toString();

    if (EmojiUitl.instance.emojiMap.containsKey(key)) {
      double size = 18;

      if (textStyle?.fontSize != null) {
        size = textStyle!.fontSize! * 1.15;
      }

      return ImageSpan(
          AssetImage(
            EmojiUitl.instance.emojiMap[key]!,
          ),
          actualText: key,
          imageWidth: size,
          imageHeight: size,
          start: start!,
          //fit: BoxFit.fill,
          margin: const EdgeInsets.all(2));
    }

    return TextSpan(text: toString(), style: textStyle);
  }
}

class EmojiUitl {
  EmojiUitl._() {
    for (int i = 1; i < 49; i++) {
      _emojiMap['[$i]'] = '$_emojiFilePath/$i.png';
    }
  }

  final Map<String, String> _emojiMap = <String, String>{};

  Map<String, String> get emojiMap => _emojiMap;

  final String _emojiFilePath = 'assets';

  static EmojiUitl? _instance;
  static EmojiUitl get instance => _instance ??= EmojiUitl._();
}
