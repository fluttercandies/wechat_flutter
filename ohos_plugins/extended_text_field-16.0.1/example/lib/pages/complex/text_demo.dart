import 'package:example/common/toggle_button.dart';
import 'package:example/data/tu_chong_repository.dart';
import 'package:example/data/tu_chong_source.dart';
import 'package:example/special_text/at_text.dart';
import 'package:example/special_text/dollar_text.dart';
import 'package:example/special_text/emoji_text.dart' as emoji;
import 'package:example/special_text/my_extended_text_selection_controls.dart';
import 'package:example/special_text/my_special_text_span_builder.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extended_keyboard/extended_keyboard.dart';
import 'package:extended_list/extended_list.dart';
import 'package:extended_text/extended_text.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:url_launcher/url_launcher.dart';

enum KeyboardPanelType {
  system,
  emoji,
  image,
  at,
  dollar,
}

@FFRoute(
  name: 'fluttercandies://TextDemo',
  routeName: 'text',
  description: 'build special text and inline image in text field',
  exts: <String, dynamic>{
    'group': 'Complex',
    'order': 0,
  },
)
class TextDemo extends StatefulWidget {
  @override
  _TextDemoState createState() => _TextDemoState();
}

class _TextDemoState extends State<TextDemo> {
  KeyboardPanelType _keyboardPanelType = KeyboardPanelType.system;
  final TextEditingController _textEditingController = TextEditingController();
  final MyTextSelectionControls _myExtendedMaterialTextSelectionControls =
      MyTextSelectionControls();
  final GlobalKey<ExtendedTextFieldState> _key =
      GlobalKey<ExtendedTextFieldState>();
  final MySpecialTextSpanBuilder _mySpecialTextSpanBuilder =
      MySpecialTextSpanBuilder();
  late TuChongRepository imageList = TuChongRepository(maxLength: 100);
  final FocusNode _focusNode = FocusNode();

  List<String> sessions = <String>[
    '[44] @Dota2 CN dota best dota',
    'yes, you are right [36].',
    '大家好，我是拉面，很萌很新 [12].',
    '\$Flutter\$. CN dev best dev',
    '\$Dota2 Ti9\$. Shanghai,I\'m coming.',
    'error 0 [45] warning 0',
  ];

  Duration duration = const Duration(milliseconds: 300);

  final ScrollController _controller = ScrollController();

  final CustomKeyboardController _customKeyboardController =
      CustomKeyboardController(KeyboardType.system);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('special text'),
        actions: <Widget>[
          TextButton(
            child: const Icon(
              Icons.backspace,
              color: Colors.white,
            ),
            onPressed: manualDelete,
          )
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _customKeyboardController.unfocus();
          },
          child: KeyboardBuilder(
            controller: _customKeyboardController,
            resizeToAvoidBottomInset: true,
            bodyBuilder: (bool readOnly) => Column(
              children: <Widget>[
                Expanded(
                    child: ExtendedListView.builder(
                  extendedListDelegate: const ExtendedListDelegate(
                    closeToTrailing: true,
                  ),
                  controller: _controller,
                  itemBuilder: (BuildContext context, int index) {
                    final bool left = index % 2 == 0;
                    final Image logo = Image.asset(
                      'assets/flutter_candies_logo.png',
                      width: 30.0,
                      height: 30.0,
                    );
                    //print(sessions[index]);
                    final Widget text = ExtendedText(
                      sessions[index],
                      textAlign: left ? TextAlign.left : TextAlign.right,
                      specialTextSpanBuilder: _mySpecialTextSpanBuilder,
                      onSpecialTextTap: (dynamic value) {
                        if (value.toString().startsWith('\$')) {
                          launchUrl(
                              Uri.parse('https://github.com/fluttercandies'));
                        } else if (value.toString().startsWith('@')) {
                          launchUrl(Uri.parse('mailto:zmtzawqlp@live.com'));
                        }
                      },
                    );
                    List<Widget> list = <Widget>[
                      logo,
                      Expanded(child: text),
                      Container(
                        width: 30.0,
                      )
                    ];
                    if (!left) {
                      list = list.reversed.toList();
                    }
                    return Row(
                      children: list,
                    );
                  },
                  padding: const EdgeInsets.only(bottom: 10.0),
                  reverse: true,
                  itemCount: sessions.length,
                )),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.blue,
                      ),
                      bottom: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      ExtendedTextField(
                        key: _key,
                        minLines: 1,
                        maxLines: 2,
                        showCursor: true,
                        readOnly: readOnly,

                        // StrutStyle get strutStyle {
                        //   if (_strutStyle == null) {
                        //     return StrutStyle.fromTextStyle(style, forceStrutHeight: true);
                        //   }
                        //   return _strutStyle!.inheritFromTextStyle(style);
                        // }
                        // default strutStyle is not good for WidgetSpan
                        strutStyle: const StrutStyle(),
                        specialTextSpanBuilder: MySpecialTextSpanBuilder(
                          showAtBackground: true,
                        ),
                        controller: _textEditingController,
                        selectionControls:
                            _myExtendedMaterialTextSelectionControls,
                        extendedContextMenuBuilder:
                            MyTextSelectionControls.defaultContextMenuBuilder,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              sendMessage(_textEditingController.text);
                              _textEditingController.clear();
                            },
                            child: const Icon(Icons.send),
                          ),
                          contentPadding: const EdgeInsets.all(12.0),
                        ),
                        onTap: () {
                          _customKeyboardController.showSystemKeyboard();
                        },
                        //textDirection: TextDirection.rtl,
                      ),
                      Container(height: 1, color: Colors.grey.withOpacity(0.3)),
                      KeyboardTypeBuilder(
                        builder: (
                          BuildContext context,
                          CustomKeyboardController controller,
                        ) =>
                            Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            createToolButton(
                              Icons.sentiment_very_satisfied,
                              KeyboardPanelType.emoji,
                              controller,
                            ),
                            createToolButton(
                              Icons.image,
                              KeyboardPanelType.image,
                              controller,
                            ),
                            createToolButton(
                              Icons.call_end,
                              KeyboardPanelType.at,
                              controller,
                            ),
                            createToolButton(
                              Icons.attach_money,
                              KeyboardPanelType.dollar,
                              controller,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            builder: (BuildContext context, double? systemKeyboardHeight) {
              return _buildCustomKeyboard(context, systemKeyboardHeight);
            },
          ),
        ),
      ),
    );
  }

  Widget createToolButton(
    IconData icon,
    KeyboardPanelType keyboardPanelType,
    CustomKeyboardController controller,
  ) {
    return ToggleButton(
      builder: (bool active) => Icon(
        icon,
        color: active ? Colors.orange : null,
      ),
      activeChanged: (bool active) {
        _keyboardPanelType = keyboardPanelType;
        if (active) {
          controller.showCustomKeyboard();
          if (!_focusNode.hasFocus) {
            SchedulerBinding.instance
                .addPostFrameCallback((Duration timeStamp) {
              _focusNode.requestFocus();
            });
          }
        } else {
          controller.showSystemKeyboard();
        }
      },
      active: controller.isCustom && _keyboardPanelType == keyboardPanelType,
    );
  }

  void insertText(String text) {
    _textEditingController.insertText(text);

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _key.currentState?.bringIntoView(_textEditingController.selection.base);
    });
  }

  void manualDelete() {
    final TextSpan oldTextSpan =
        _mySpecialTextSpanBuilder.build(_textEditingController.text);

    final TextEditingValue value =
        ExtendedTextLibraryUtils.handleSpecialTextSpanDelete(
      _textEditingController.deleteText(),
      _textEditingController.value,
      oldTextSpan,
      null,
    );
    _textEditingController.value = value;
  }

  void sendMessage(String text) {
    if (text.isEmpty) {
      return;
    }
    setState(() {
      sessions.insert(0, text);
    });
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _controller.animateTo(
        _controller.position.minScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _buildCustomKeyboard(
    BuildContext context,
    double? systemKeyboardHeight,
  ) {
    systemKeyboardHeight ??= 346;

    switch (_keyboardPanelType) {
      case KeyboardPanelType.emoji:
        return SizedBox(
          height: systemKeyboardHeight,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Image.asset(
                    emoji.EmojiUitl.instance.emojiMap['[${index + 1}]']!),
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  insertText('[${index + 1}]');
                },
              );
            },
            itemCount: emoji.EmojiUitl.instance.emojiMap.length,
            padding: const EdgeInsets.all(5.0),
          ),
        );
      case KeyboardPanelType.image:
        return SizedBox(
          height: systemKeyboardHeight,
          child: LoadingMoreList<TuChongItem>(
            ListConfig<TuChongItem>(
              sourceList: imageList,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (BuildContext context, TuChongItem item, int index) {
                final String url = item.imageUrl;
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    // <img src="http://pic2016.5442.com:82/2016/0513/12/3.jpg!960.jpg"/>

                    sendMessage(
                        "<img src='$url'  width='${item.imageSize.width}' height='${item.imageSize.height}'/>");
                  },
                  child: ExtendedImage.network(
                    url,
                  ),
                );
              },
              padding: const EdgeInsets.all(5.0),
            ),
          ),
        );
      case KeyboardPanelType.at:
        return SizedBox(
          height: systemKeyboardHeight,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0),
            itemBuilder: (BuildContext context, int index) {
              final String text = atList[index];
              return GestureDetector(
                child: Align(
                  child: Text(text),
                ),
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  insertText(text);
                },
              );
            },
            itemCount: atList.length,
            padding: const EdgeInsets.all(5.0),
          ),
        );
      case KeyboardPanelType.dollar:
        return SizedBox(
          height: systemKeyboardHeight,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0),
            itemBuilder: (BuildContext context, int index) {
              final String text = dollarList[index];
              return GestureDetector(
                child: Align(
                  child: Text(text.replaceAll('\$', '')),
                ),
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  insertText(text);
                },
              );
            },
            itemCount: dollarList.length,
            padding: const EdgeInsets.all(5.0),
          ),
        );
      default:
        return Container();
    }
  }
}
