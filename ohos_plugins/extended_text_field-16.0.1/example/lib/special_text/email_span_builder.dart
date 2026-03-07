import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/material.dart';

import 'email_text.dart';

///
///  create by zmtzawqlp on 2019/8/4
///

class EmailSpanBuilder extends SpecialTextSpanBuilder {
  EmailSpanBuilder(this.controller, this.context);
  final TextEditingController controller;
  final BuildContext context;
  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      int? index}) {
    if (flag == '') {
      return null;
    }

    if (!flag.startsWith(' ') && !flag.startsWith('@')) {
      return EmailText(textStyle!, onTap,
          start: index,
          context: context,
          controller: controller,
          startFlag: flag);
    }
    return null;
  }
}
