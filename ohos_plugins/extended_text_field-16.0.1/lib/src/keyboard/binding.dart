import 'package:extended_text_field/src/keyboard/focus_node.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// void main() {
///   TextInputBinding();
///   runApp(const MyApp());
/// }
class TextInputBinding extends WidgetsFlutterBinding
    with TextInputBindingMixin {}

/// class YourBinding extends WidgetsFlutterBinding with TextInputBindingMixin,YourBindingMixin {
///   @override
///   // ignore: unnecessary_overrides
///   bool ignoreTextInputShow() {
///     // you can override it base on your case
///     // if NoKeyboardFocusNode is not enough
///     return super.ignoreTextInputShow();
///   }
/// }
///
/// void main() {
///   YourBinding();
///   runApp(const MyApp());
/// }
mixin TextInputBindingMixin on WidgetsFlutterBinding {
  @override
  BinaryMessenger createBinaryMessenger() {
    return TextInputBinaryMessenger(super.createBinaryMessenger(), this);
  }

  bool ignoreSendMessage(MethodCall methodCall) => false;

  bool ignoreTextInputShow() {
    final FocusNode? focus = FocusManager.instance.primaryFocus;
    if (focus != null &&
        focus is TextInputFocusNode &&
        focus.ignoreSystemKeyboardShow) {
      return true;
    }
    return false;
  }
}

class TextInputBinaryMessenger extends BinaryMessenger {
  TextInputBinaryMessenger(this.origin, this.textInputBindingMixin);
  final BinaryMessenger origin;
  final TextInputBindingMixin textInputBindingMixin;
  @override
  Future<void> handlePlatformMessage(String channel, ByteData? data,
      PlatformMessageResponseCallback? callback) async {
    ServicesBinding.instance.channelBuffers.push(
      channel,
      data,
      (ByteData? data) {
        callback?.call(data);
      },
    );
  }

  @override
  Future<ByteData?>? send(String channel, ByteData? message) async {
    if (channel == SystemChannels.textInput.name) {
      final MethodCall methodCall =
          SystemChannels.textInput.codec.decodeMethodCall(message);
      bool ignore = false;
      switch (methodCall.method) {
        case 'TextInput.show':
          ignore = textInputBindingMixin.ignoreTextInputShow();
          break;
        default:
          ignore = textInputBindingMixin.ignoreSendMessage(methodCall);
      }

      if (ignore) {
        return null;
      }
    }
    return origin.send(channel, message);
  }

  @override
  void setMessageHandler(String channel, MessageHandler? handler) {
    origin.setMessageHandler(channel, handler);
  }
}
