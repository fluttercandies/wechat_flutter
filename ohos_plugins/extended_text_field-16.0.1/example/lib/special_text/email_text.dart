import 'dart:ui' as ui show PlaceholderAlignment;
import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/material.dart';

class EmailText extends SpecialText {
  EmailText(TextStyle textStyle, SpecialTextGestureTapCallback? onTap,
      {this.start, this.controller, this.context, required String startFlag})
      : super(startFlag, ' ', textStyle, onTap: onTap);
  final TextEditingController? controller;
  final int? start;
  final BuildContext? context;
  @override
  bool isEnd(String value) {
    final int index = value.indexOf('@');
    final int index1 = value.indexOf('.');

    return index >= 0 &&
        index1 >= 0 &&
        index1 > index + 1 &&
        super.isEnd(value);
  }

  @override
  InlineSpan finishText() {
    final String text = toString();

    return ExtendedWidgetSpan(
      actualText: text,
      start: start!,
      alignment: ui.PlaceholderAlignment.middle,
      child: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.only(right: 5.0, top: 2.0, bottom: 2.0),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Container(
                padding: const EdgeInsets.all(5.0),
                color: Colors.orange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      text.trim(),
                      //style: textStyle?.copyWith(color: Colors.orange),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    InkWell(
                      child: const Icon(
                        Icons.close,
                        size: 15.0,
                      ),
                      onTap: () {
                        controller!.value = controller!.value.copyWith(
                            text: controller!.text
                                .replaceRange(start!, start! + text.length, ''),
                            selection: TextSelection.fromPosition(
                                TextPosition(offset: start!)));
                      },
                    )
                  ],
                ),
              )),
        ),
        onTap: () {
          showDialog<void>(
              context: context!,
              barrierDismissible: true,
              builder: (BuildContext c) {
                final TextEditingController textEditingController =
                    TextEditingController()..text = text.trim();
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    Material(
                        child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                            suffixIcon: TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            controller!.value = controller!.value.copyWith(
                                text: controller!.text.replaceRange(
                                    start!,
                                    start! + text.length,
                                    textEditingController.text + ' '),
                                selection: TextSelection.fromPosition(
                                    TextPosition(
                                        offset: start! +
                                            (textEditingController.text + ' ')
                                                .length)));

                            Navigator.pop(context!);
                          },
                        )),
                      ),
                    )),
                    Expanded(
                      child: Container(),
                    )
                  ],
                );
              });
        },
      ),
      deleteAll: true,
    );
  }
}
