import 'package:extended_keyboard/extended_keyboard.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

class CustomKeyboarBinding extends TextInputBinding with KeyboardBindingMixin {
  @override
  // ignore: unnecessary_overrides
  bool ignoreTextInputShow() {
    // you can override it base on your case
    // if NoKeyboardFocusNode is not enough
    return super.ignoreTextInputShow();
  }
}

@FFRoute(
  name: 'fluttercandies://NoKeyboard',
  routeName: 'no system Keyboard',
  description: 'show how to ignore system keyboard and show custom keyboard',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 2,
  },
)
class NoSystemKeyboardDemo extends StatelessWidget {
  const NoSystemKeyboardDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('no system Keyboard'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
            Text('ExtendedTextField'),
            ExtendedTextFieldCase(),
            Text('CustomTextField'),
            TextFieldCase(),
          ]),
        ),
      ),
    );
  }
}

class ExtendedTextFieldCase extends StatefulWidget {
  const ExtendedTextFieldCase({Key? key}) : super(key: key);

  @override
  State<ExtendedTextFieldCase> createState() => _ExtendedTextFieldCaseState();
}

class _ExtendedTextFieldCaseState extends State<ExtendedTextFieldCase>
    with CustomKeyboardShowStateMixin {
  @override
  Widget build(BuildContext context) {
    return ExtendedTextField(
      // you must use TextInputFocusNode
      focusNode: _focusNode..debugLabel = 'ExtendedTextField',
      // if your custom keyboard can be close without unfocus
      // you can show custom keyboard when TextField onTap
      controller: _controller,
      maxLines: null,
      inputFormatters: _inputFormatters,
    );
  }
}

class TextFieldCase extends StatefulWidget {
  const TextFieldCase({Key? key}) : super(key: key);
  @override
  State<TextFieldCase> createState() => TextFieldCaseState();
}

class TextFieldCaseState extends State<TextFieldCase>
    with CustomKeyboardShowStateMixin {
  @override
  Widget build(BuildContext context) {
    return TextField(
      // you must use TextInputFocusNode
      focusNode: _focusNode..debugLabel = 'CustomTextField',
      // if your custom keyboard can be close without unfocus
      // you can show custom keyboard when TextField onTap
      onTap: _onTextFiledTap,
      controller: _controller,
      inputFormatters: _inputFormatters,
      maxLines: null,
    );
  }
}

@optionalTypeArgs
mixin CustomKeyboardShowStateMixin<T extends StatefulWidget> on State<T> {
  final TextInputFocusNode _focusNode = TextInputFocusNode();
  final TextEditingController _controller = TextEditingController();
  PersistentBottomSheetController? _bottomSheetController;

  final List<TextInputFormatter> _inputFormatters = <TextInputFormatter>[
    // digit or decimal
    FilteringTextInputFormatter.allow(RegExp(r'[1-9]{1}[0-9.]*')),
    // only one decimal
    TextInputFormatter.withFunction(
        (TextEditingValue oldValue, TextEditingValue newValue) =>
            newValue.text.indexOf('.') != newValue.text.lastIndexOf('.')
                ? oldValue
                : newValue),
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  void _onTextFiledTap() {
    if (_bottomSheetController == null) {
      _handleFocusChanged();
    }
  }

  void _handleFocusChanged() {
    if (_focusNode.hasFocus) {
      // just demo, you can define your custom keyboard as you want
      _bottomSheetController = showBottomSheet(
          context: FocusManager.instance.primaryFocus!.context!,
          // set false, if don't want to drag to close custom keyboard
          enableDrag: true,
          builder: (BuildContext b) {
            final MediaQueryData mediaQueryData = MediaQuery.of(b);

            return Material(
              //shadowColor: Colors.grey,
              color: Colors.grey.withOpacity(0.3),
              //elevation: 8,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 20,
                  bottom: mediaQueryData.viewPadding.bottom /
                      mediaQueryData.devicePixelRatio,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        flex: 15,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: NumberButton(
                                    number: 1,
                                    insertText: insertText,
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: NumberButton(
                                    number: 2,
                                    insertText: insertText,
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: NumberButton(
                                    number: 3,
                                    insertText: insertText,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: NumberButton(
                                    number: 4,
                                    insertText: insertText,
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: NumberButton(
                                    number: 5,
                                    insertText: insertText,
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: NumberButton(
                                    number: 6,
                                    insertText: insertText,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: NumberButton(
                                    number: 7,
                                    insertText: insertText,
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: NumberButton(
                                    number: 8,
                                    insertText: insertText,
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: NumberButton(
                                    number: 9,
                                    insertText: insertText,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 5,
                                  child: CustomButton(
                                    child: const Text('.'),
                                    onTap: () {
                                      insertText('.');
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: NumberButton(
                                    number: 0,
                                    insertText: insertText,
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: CustomButton(
                                    child: const Icon(Icons.arrow_downward),
                                    onTap: () {
                                      _focusNode.unfocus();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                                child: CustomButton(
                              child: const Icon(Icons.backspace),
                              onTap: () {
                                manualDelete();
                              },
                            )),
                            Expanded(
                                child: CustomButton(
                              child: const Icon(Icons.keyboard_return),
                              onTap: () {
                                showToast('onSubmitted: ${_controller.text}');
                              },
                            ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
      // maybe drag close
      _bottomSheetController?.closed.whenComplete(() {
        _bottomSheetController = null;
      });
    } else {
      _bottomSheetController?.close();
      _bottomSheetController = null;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    super.dispose();
  }

  void insertText(String text) {
    final TextEditingValue oldValue = _controller.value;
    TextEditingValue newValue = oldValue;
    final int start = oldValue.selection.baseOffset;
    int end = oldValue.selection.extentOffset;
    if (oldValue.selection.isValid) {
      String newText = '';
      if (oldValue.selection.isCollapsed) {
        if (end > 0) {
          newText += oldValue.text.substring(0, end);
        }
        newText += text;
        if (oldValue.text.length > end) {
          newText += oldValue.text.substring(end, oldValue.text.length);
        }
      } else {
        newText = oldValue.text.replaceRange(start, end, text);
        end = start;
      }

      newValue = oldValue.copyWith(
          text: newText,
          selection: oldValue.selection.copyWith(
              baseOffset: end + text.length, extentOffset: end + text.length));
    } else {
      newValue = TextEditingValue(
          text: text,
          selection:
              TextSelection.fromPosition(TextPosition(offset: text.length)));
    }
    for (final TextInputFormatter inputFormatter in _inputFormatters) {
      newValue = inputFormatter.formatEditUpdate(oldValue, newValue);
    }

    _controller.value = newValue;
  }

  void manualDelete() {
    //delete by code
    final TextEditingValue _value = _controller.value;
    final TextSelection selection = _value.selection;
    if (!selection.isValid) {
      return;
    }

    TextEditingValue value;
    final String actualText = _value.text;
    if (selection.isCollapsed && selection.start == 0) {
      return;
    }
    final int start =
        selection.isCollapsed ? selection.start - 1 : selection.start;
    final int end = selection.end;

    value = TextEditingValue(
      text: actualText.replaceRange(start, end, ''),
      selection: TextSelection.collapsed(offset: start),
    );

    _controller.value = value;
  }
}

class NumberButton extends StatelessWidget {
  const NumberButton({
    Key? key,
    required this.number,
    required this.insertText,
  }) : super(key: key);
  final int number;
  final Function(String text) insertText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        insertText('$number');
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        height: 50,
        child: Text(
          '$number',
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);
  final Widget child;
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        height: 50,
        child: child,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
