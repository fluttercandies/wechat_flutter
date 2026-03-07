# extended_text_field

[![pub package](https://img.shields.io/pub/v/extended_text_field.svg)](https://pub.dartlang.org/packages/extended_text_field) [![GitHub stars](https://img.shields.io/github/stars/fluttercandies/extended_text_field)](https://github.com/fluttercandies/extended_text_field/stargazers) [![GitHub forks](https://img.shields.io/github/forks/fluttercandies/extended_text_field)](https://github.com/fluttercandies/extended_text_field/network)  [![GitHub license](https://img.shields.io/github/license/fluttercandies/extended_text_field)](https://github.com/fluttercandies/extended_text_field/blob/master/LICENSE)  [![GitHub issues](https://img.shields.io/github/issues/fluttercandies/extended_text_field)](https://github.com/fluttercandies/extended_text_field/issues) <a target="_blank" href="https://jq.qq.com/?_wv=1027&k=5bcc0gy"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="flutter-candies" title="flutter-candies"></a>

文档语言: [English](README.md) | 中文简体

官方输入框的扩展组件，支持图片，@某人，自定义文字背景。也支持自定义菜单和选择器。

[ExtendedTextField 在线 Demo](https://fluttercandies.github.io/extended_text_field/)

ExtendedTextField  是 Flutter 官方 TextField  的三方扩展库，主要扩展功能如下:

| 功能                                      | ExtendedTextField                                        |  TextField                                     |
|-----------------------------------------|---------------------------------------------------------|----------------------------------------------------------|
| 图文混合                                 | 支持，可以实现图文混合显示                                   | 仅支持显示文本，但在选择文本时会出现问题                     |
| 支持复制真实值                            | 支持，可以复制出文本的真实值                                 | 不支持                         |
| 根据文本格式快速构建富文本                   | 支持，可以根据文本格式快速构建富文本                           | 不支持                                                        |

> 已支持 `HarmonyOS`. 请使用最新的带有 `ohos` 标志的版本. 你可以在 `Versions` 签查找.

```yaml
dependencies:
  extended_text_field: 11.0.1-ohos
```


- [extended\_text\_field](#extended_text_field)
  - [限制](#限制)
  - [特殊文本](#特殊文本)
    - [创建特殊文本](#创建特殊文本)
    - [特殊文本Builder](#特殊文本builder)
  - [图片](#图片)
    - [ImageSpan](#imagespan)
    - [缓存图片](#缓存图片)
  - [文本选择控制器](#文本选择控制器)
  - [WidgetSpan](#widgetspan)
  - [阻止系统键盘](#阻止系统键盘)
    - [TextInputBindingMixin](#textinputbindingmixin)
    - [TextInputFocusNode](#textinputfocusnode)
    - [CustomKeyboard](#customkeyboard)
  - [☕️Buy me a coffee](#️buy-me-a-coffee)

## 限制

- 不支持TextDirection.rtl，从右向左.

- 不支持obscureText为true.

## 特殊文本

![](https://github.com/fluttercandies/Flutter_Candies/blob/master/gif/extended_text_field/extended_text_field.gif)

### 创建特殊文本

extended_text 帮助将字符串文本快速转换为特殊的TextSpan

下面的例子告诉你怎么创建一个@xxx

具体思路是对字符串进行进栈遍历，通过判断flag来判定是否是一个特殊字符。
例子：@zmtzawqlp ，以@开头并且以空格结束，我们就认为它是一个@的特殊文本

```dart
class AtText extends SpecialText {
  static const String flag = "@";
  final int start;

  /// whether show background for @somebody
  final bool showAtBackground;

  AtText(TextStyle textStyle, SpecialTextGestureTapCallback onTap,
      {this.showAtBackground: false, this.start})
      : super(
          flag,
          " ",
          textStyle,
        );

  @override
  InlineSpan finishText() {
    TextStyle textStyle =
        this.textStyle?.copyWith(color: Colors.blue, fontSize: 16.0);

    final String atText = toString();

    return showAtBackground
        ? BackgroundTextSpan(
            background: Paint()..color = Colors.blue.withOpacity(0.15),
            text: atText,
            actualText: atText,
            start: start,

            ///caret can move into special text
            deleteAll: true,
            style: textStyle,
            recognizer: (TapGestureRecognizer()
              ..onTap = () {
                if (onTap != null) onTap(atText);
              }))
        : SpecialTextSpan(
            text: atText,
            actualText: atText,
            start: start,
            style: textStyle,
            recognizer: (TapGestureRecognizer()
              ..onTap = () {
                if (onTap != null) onTap(atText);
              }));
  }
}

```

### 特殊文本Builder

创建属于你自己规则的Builder，上面说了你可以继承SpecialText来定义各种各样的特殊文本。
- build 方法中，是通过具体思路是对字符串进行进栈遍历，通过判断flag来判定是否是一个特殊文本。
  感兴趣的，可以看一下SpecialTextSpanBuilder里面build方法的实现，当然你也可以写出属于自己的build逻辑
- createSpecialText 通过判断flag来判定是否是一个特殊文本

```dart
class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  /// whether show background for @somebody
  final bool showAtBackground;
  final BuilderType type;
  MySpecialTextSpanBuilder(
      {this.showAtBackground: false, this.type: BuilderType.extendedText});

  @override
  TextSpan build(String data, {TextStyle textStyle, onTap}) {
    var textSpan = super.build(data, textStyle: textStyle, onTap: onTap);
    return textSpan;
  }

  @override
  SpecialText createSpecialText(String flag,
      {TextStyle textStyle, SpecialTextGestureTapCallback onTap, int index}) {
    if (flag == null || flag == "") return null;

    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    if (isStart(flag, AtText.flag)) {
      return AtText(textStyle, onTap,
          start: index - (AtText.flag.length - 1),
          showAtBackground: showAtBackground,
          type: type);
    } else if (isStart(flag, EmojiText.flag)) {
      return EmojiText(textStyle, start: index - (EmojiText.flag.length - 1));
    } else if (isStart(flag, DollarText.flag)) {
      return DollarText(textStyle, onTap,
          start: index - (DollarText.flag.length - 1), type: type);
    }
    return null;
  }
}
```
其实你也不是一定要用这套代码将字符串转换为TextSpan，你可以有自己的方法，给最后的TextSpan就可以了。

## 图片

![](https://github.com/fluttercandies/Flutter_Candies/blob/master/gif/extended_text_field/extended_text_field_image.gif)

### ImageSpan

使用ImageSpan 展示图片

```dart
ImageSpan(
    ImageProvider image, {
    Key key,
    @required double imageWidth,
    @required double imageHeight,
    EdgeInsets margin,
    int start: 0,
    ui.PlaceholderAlignment alignment = ui.PlaceholderAlignment.bottom,
    String actualText,
    TextBaseline baseline,
    TextStyle style,
    BoxFit fit: BoxFit.scaleDown,
    ImageLoadingBuilder loadingBuilder,
    ImageFrameBuilder frameBuilder,
    String semanticLabel,
    bool excludeFromSemantics = false,
    Color color,
    BlendMode colorBlendMode,
    AlignmentGeometry imageAlignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    FilterQuality filterQuality = FilterQuality.low,
  })

ImageSpan(AssetImage("xxx.jpg"),
        imageWidth: size,
        imageHeight: size,
        margin: EdgeInsets.only(left: 2.0, bottom: 0.0, right: 2.0));
  }
```

| 参数        | 描述                                                              | 默认             |
| ----------- | ----------------------------------------------------------------- | ---------------- |
| image       | 图片展示的Provider(ImageProvider)                                 | -                |
| imageWidth  | 宽度，不包括 margin                                               | 必填             |
| imageHeight | 高度，不包括 margin                                               | 必填             |
| margin      | 图片的margin                                                      | -                |
| actualText  | 真实的文本,当你开启文本选择功能的时候，必须设置,比如图片"\[love\] | 空占位符'\uFFFC' |
| start       | 在文本字符串中的开始位置,当你开启文本选择功能的时候，必须设置     | 0                |

### 缓存图片

你可以用ExtendedNetworkImageProvider来缓存文本中的图片，使用clearDiskCachedImages方法来清掉本地缓存

引入 extended_image_library

```dart
dependencies:
  extended_image_library: ^0.1.4
```

```dart
ExtendedNetworkImageProvider(
  this.url, {
  this.scale = 1.0,
  this.headers,
  this.cache: false,
  this.retries = 3,
  this.timeLimit,
  this.timeRetry = const Duration(milliseconds: 100),
  CancellationToken cancelToken,
})  : assert(url != null),
      assert(scale != null),
      cancelToken = cancelToken ?? CancellationToken();
```

| 参数        | 描述                | 默认                |
| ----------- | ------------------- | ------------------- |
| url         | 网络请求地址        | required            |
| scale       | ImageInfo中的scale  | 1.0                 |
| headers     | HttpClient的headers | -                   |
| cache       | 是否缓存到本地      | false               |
| retries     | 请求尝试次数        | 3                   |
| timeLimit   | 请求超时            | -                   |
| timeRetry   | 请求重试间隔        | milliseconds: 100   |
| cancelToken | 用于取消请求的Token | CancellationToken() |

```dart
/// Clear the disk cache directory then return if it succeed.
///  <param name="duration">timespan to compute whether file has expired or not</param>
Future<bool> clearDiskCachedImages({Duration duration}) async
```

## 文本选择控制器

![](https://github.com/fluttercandies/Flutter_Candies/blob/master/gif/extended_text_field/custom_toolbar.gif)

提供了默认的控制器MaterialExtendedTextSelectionControls/CupertinoExtendedTextSelectionControls

通过重写 [ExtendedTextField.extendedContextMenuBuilder] 和 [TextSelectionControls] 来自定义菜单和选择器。

```dart
const double _kHandleSize = 22.0;

/// Android Material styled text selection controls.
class MyTextSelectionControls extends TextSelectionControls
    with TextSelectionHandleControls {
  static Widget defaultContextMenuBuilder(
      BuildContext context, ExtendedEditableTextState editableTextState) {
    return AdaptiveTextSelectionToolbar.buttonItems(
      buttonItems: <ContextMenuButtonItem>[
        ...editableTextState.contextMenuButtonItems,
        ContextMenuButtonItem(
          onPressed: () {
            launchUrl(
              Uri.parse(
                'mailto:zmtzawqlp@live.com?subject=extended_text_share&body=${editableTextState.textEditingValue.text}',
              ),
            );
            editableTextState.hideToolbar(true);
            editableTextState.textEditingValue
                .copyWith(selection: const TextSelection.collapsed(offset: 0));
          },
          type: ContextMenuButtonType.custom,
          label: 'like',
        ),
      ],
      anchors: editableTextState.contextMenuAnchors,
    );
    // return AdaptiveTextSelectionToolbar.editableText(
    //   editableTextState: editableTextState,
    // );
  }

  /// Returns the size of the Material handle.
  @override
  Size getHandleSize(double textLineHeight) =>
      const Size(_kHandleSize, _kHandleSize);

  /// Builder for material-style text selection handles.
  @override
  Widget buildHandle(
      BuildContext context, TextSelectionHandleType type, double textLineHeight,
      [VoidCallback? onTap, double? startGlyphHeight, double? endGlyphHeight]) {
    final Widget handle = SizedBox(
      width: _kHandleSize,
      height: _kHandleSize,
      child: Image.asset(
        'assets/40.png',
      ),
    );

    // [handle] is a circle, with a rectangle in the top left quadrant of that
    // circle (an onion pointing to 10:30). We rotate [handle] to point
    // straight up or up-right depending on the handle type.
    switch (type) {
      case TextSelectionHandleType.left: // points up-right
        return Transform.rotate(
          angle: math.pi / 4.0,
          child: handle,
        );
      case TextSelectionHandleType.right: // points up-left
        return Transform.rotate(
          angle: -math.pi / 4.0,
          child: handle,
        );
      case TextSelectionHandleType.collapsed: // points up
        return handle;
    }
  }

  /// Gets anchor for material-style text selection handles.
  ///
  /// See [TextSelectionControls.getHandleAnchor].
  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight,
      [double? startGlyphHeight, double? endGlyphHeight]) {
    switch (type) {
      case TextSelectionHandleType.left:
        return const Offset(_kHandleSize, 0);
      case TextSelectionHandleType.right:
        return Offset.zero;
      default:
        return const Offset(_kHandleSize / 2, -4);
    }
  }

  @override
  bool canSelectAll(TextSelectionDelegate delegate) {
    // Android allows SelectAll when selection is not collapsed, unless
    // everything has already been selected.
    final TextEditingValue value = delegate.textEditingValue;
    return delegate.selectAllEnabled &&
        value.text.isNotEmpty &&
        !(value.selection.start == 0 &&
            value.selection.end == value.text.length);
  }
}

```

## WidgetSpan

![](https://github.com/fluttercandies/Flutter_Candies/blob/master/gif/extended_text_field/widget_span.gif)

ExtendedWidgetSpan 支持选择以及hitTest, 所以你可以在输入框中加入任何的widget。

```dart
class EmailText extends SpecialText {
  final TextEditingController controller;
  final int start;
  final BuildContext context;
  EmailText(TextStyle textStyle, SpecialTextGestureTapCallback onTap,
      {this.start, this.controller, this.context, String startFlag})
      : super(startFlag, " ", textStyle, onTap: onTap);

  @override
  bool isEnd(String value) {
    var index = value.indexOf("@");
    var index1 = value.indexOf(".");

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
      start: start,
      alignment: ui.PlaceholderAlignment.middle,
      child: GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(right: 5.0, top: 2.0, bottom: 2.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Container(
                padding: EdgeInsets.all(5.0),
                color: Colors.orange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      text.trim(),
                      //style: textStyle?.copyWith(color: Colors.orange),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    InkWell(
                      child: Icon(
                        Icons.close,
                        size: 15.0,
                      ),
                      onTap: () {
                        controller.value = controller.value.copyWith(
                            text: controller.text
                                .replaceRange(start, start + text.length, ""),
                            selection: TextSelection.fromPosition(
                                TextPosition(offset: start)));
                      },
                    )
                  ],
                ),
              )),
        ),
        onTap: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (c) {
                TextEditingController textEditingController =
                    TextEditingController()..text = text.trim();
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    Material(
                        child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                            suffixIcon: FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            controller.value = controller.value.copyWith(
                                text: controller.text.replaceRange(
                                    start,
                                    start + text.length,
                                    textEditingController.text + " "),
                                selection: TextSelection.fromPosition(
                                    TextPosition(
                                        offset: start +
                                            (textEditingController.text + " ")
                                                .length)));

                            Navigator.pop(context);
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
```

## 阻止系统键盘

我们不需要代码侵入到 [ExtendedTextField] 或者 [TextField] 当中， 就可以阻止系统键盘弹出，

### TextInputBindingMixin

我们通过阻止 Flutter Framework 发送 `TextInput.show` 到 Flutter 引擎来阻止系统键盘弹出

你可以直接使用 [TextInputBinding].

``` dart
void main() {
  TextInputBinding();
  runApp(const MyApp());
}
```

或者你如果有其他的 `binding`，你可以这样。

``` dart
 class YourBinding extends WidgetsFlutterBinding with TextInputBindingMixin,YourBindingMixin {
 }

 void main() {
   YourBinding();
   runApp(const MyApp());
 }
```

或者你需要重载 `ignoreTextInputShow` 方法，你可以这样。

``` dart
 class YourBinding extends TextInputBinding {
   @override
   // ignore: unnecessary_overrides
   bool ignoreTextInputShow() {
     // you can override it base on your case
     // if NoKeyboardFocusNode is not enough
     return super.ignoreTextInputShow();
   }
 }

 void main() {
   YourBinding();
   runApp(const MyApp());
 }
```

### TextInputFocusNode

把 [TextInputFocusNode]  传递给 [ExtendedTextField] 或者 [TextField]。


``` dart
final TextInputFocusNode _focusNode = TextInputFocusNode();

  @override
  Widget build(BuildContext context) {
    return ExtendedTextField(
      // request keyboard if need
      focusNode: _focusNode..debugLabel = 'ExtendedTextField',
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      // request keyboard if need
      focusNode: _focusNode..debugLabel = 'CustomTextField',
    );
  }
```

我们通过当前的 `FocusNode` 是否是 [TextInputFocusNode],来决定是否阻止系统键盘弹出的。

``` dart
  final FocusNode? focus = FocusManager.instance.primaryFocus;
  if (focus != null &&
      focus is TextInputFocusNode &&
      focus.ignoreSystemKeyboardShow) {
    return true;
  }
```
### CustomKeyboard

你可以通过当前焦点的变化的时候，来显示或者隐藏自定义的键盘。

当你的自定义键盘可以关闭而不让焦点失去，你应该在 [ExtendedTextField] 或者 [TextField]
的 `onTap` 事件中，再次判断键盘是否显示。

``` dart
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
      _bottomSheetController = showBottomSheet<void>(
          context: FocusManager.instance.primaryFocus!.context!,
          // set false, if don't want to drag to close custom keyboard
          enableDrag: true,
          builder: (BuildContext b) {
            // your custom keyboard
            return Container();
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
```


查看 [完整的例子](https://github.com/fluttercandies/extended_text_field/tree/master/example/lib/pages/simple/no_keyboard.dart)

## ☕️Buy me a coffee

![img](http://zmtzawqlp.gitee.io/my_images/images/qrcode.png)
