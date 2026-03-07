import 'package:flutter/widgets.dart';

/// The FocusNode to be used in [TextInputBindingMixin]
///
class TextInputFocusNode extends FocusNode {
  /// no system keyboard show
  /// if it's true, it stop Flutter Framework send `TextInput.show` message to Flutter Engine
  bool ignoreSystemKeyboardShow = true;
}
