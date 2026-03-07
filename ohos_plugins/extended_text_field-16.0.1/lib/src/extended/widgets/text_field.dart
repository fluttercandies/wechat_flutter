import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:extended_text_field/src/extended/cupertino/spell_check_suggestions_toolbar.dart';
import 'package:extended_text_field/src/extended/material/spell_check_suggestions_toolbar.dart';
import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

part 'package:extended_text_field/src/extended/rendering/editable.dart';
part 'package:extended_text_field/src/extended/widgets/editable_text.dart';
part 'package:extended_text_field/src/extended/widgets/spell_check.dart';
part 'package:extended_text_field/src/extended/widgets/text_selection.dart';
part 'package:extended_text_field/src/extended/material/selectable_text.dart';
part 'package:extended_text_field/src/official/rendering/editable.dart';
part 'package:extended_text_field/src/official/widgets/editable_text.dart';
part 'package:extended_text_field/src/official/widgets/text_field.dart';
part 'package:extended_text_field/src/official/widgets/text_selection.dart';
part 'package:extended_text_field/src/official/widgets/spell_check.dart';
part 'package:extended_text_field/src/official/material/selectable_text.dart';

class ExtendedTextField extends _TextField {
  const ExtendedTextField({
    super.key,
    super.groupId = EditableText,
    super.controller,
    super.focusNode,
    super.undoController,
    super.decoration = const InputDecoration(),
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization = TextCapitalization.none,
    super.style,
    super.strutStyle,
    super.textAlign = TextAlign.start,
    super.textAlignVertical,
    super.textDirection,
    super.readOnly = false,
    @Deprecated(
      'Use `contextMenuBuilder` instead. '
      'This feature was deprecated after v3.3.0-0.5.pre.',
    )
    super.toolbarOptions,
    super.showCursor,
    super.autofocus = false,
    super.statesController,
    super.obscuringCharacter = '•',
    super.obscureText = false,
    super.autocorrect = true,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions = true,
    super.maxLines = 1,
    super.minLines,
    super.expands = false,
    super.maxLength,
    super.maxLengthEnforcement,
    super.onChanged,
    super.onEditingComplete,
    super.onSubmitted,
    super.onAppPrivateCommand,
    super.inputFormatters,
    super.enabled,
    super.cursorWidth = 2.0,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorOpacityAnimates,
    super.cursorColor,
    super.cursorErrorColor,
    super.selectionHeightStyle = ui.BoxHeightStyle.tight,
    super.selectionWidthStyle = ui.BoxWidthStyle.tight,
    super.keyboardAppearance,
    super.scrollPadding = const EdgeInsets.all(20.0),
    super.dragStartBehavior = DragStartBehavior.start,
    super.enableInteractiveSelection,
    super.selectionControls,
    super.onTap,
    super.onTapAlwaysCalled = false,
    super.onTapOutside,
    super.mouseCursor,
    super.buildCounter,
    super.scrollController,
    super.scrollPhysics,
    super.autofillHints = const <String>[],
    super.contentInsertionConfiguration,
    super.clipBehavior = Clip.hardEdge,
    super.restorationId,
    super.scribbleEnabled = true,
    super.enableIMEPersonalizedLearning = true,
    // zmtzwqlp
    // super.contextMenuBuilder = _defaultContextMenuBuilder,
    this.extendedContextMenuBuilder = _defaultContextMenuBuilder,
    super.canRequestFocus = true,
    // zmtzawqlp
    // super.spellCheckConfiguration,
    this.extendedSpellCheckConfiguration,
    this.specialTextSpanBuilder,
    super.magnifierConfiguration,
  });

  /// build your ccustom text span
  final SpecialTextSpanBuilder? specialTextSpanBuilder;

  /// {@template flutter.widgets.EditableText.contextMenuBuilder}
  /// Builds the text selection toolbar when requested by the user.
  ///
  /// `primaryAnchor` is the desired anchor position for the context menu, while
  /// `secondaryAnchor` is the fallback location if the menu doesn't fit.
  ///
  /// `buttonItems` represents the buttons that would be built by default for
  /// this widget.
  ///
  /// {@tool dartpad}
  /// This example shows how to customize the menu, in this case by keeping the
  /// default buttons for the platform but modifying their appearance.
  ///
  /// ** See code in examples/api/lib/material/context_menu/editable_text_toolbar_builder.0.dart **
  /// {@end-tool}
  ///
  /// {@tool dartpad}
  /// This example shows how to show a custom button only when an email address
  /// is currently selected.
  ///
  /// ** See code in examples/api/lib/material/context_menu/editable_text_toolbar_builder.1.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///   * [AdaptiveTextSelectionToolbar], which builds the default text selection
  ///     toolbar for the current platform, but allows customization of the
  ///     buttons.
  ///   * [AdaptiveTextSelectionToolbar.getAdaptiveButtons], which builds the
  ///     button Widgets for the current platform given
  ///     [ContextMenuButtonItem]s.
  ///   * [BrowserContextMenu], which allows the browser's context menu on web
  ///     to be disabled and Flutter-rendered context menus to appear.
  /// {@endtemplate}
  ///
  /// If not provided, no context menu will be shown.
  final ExtendedEditableTextContextMenuBuilder? extendedContextMenuBuilder;

  /// {@template flutter.widgets.EditableText.spellCheckConfiguration}
  /// Configuration that details how spell check should be performed.
  ///
  /// Specifies the [SpellCheckService] used to spell check text input and the
  /// [TextStyle] used to style text with misspelled words.
  ///
  /// If the [SpellCheckService] is left null, spell check is disabled by
  /// default unless the [DefaultSpellCheckService] is supported, in which case
  /// it is used. It is currently supported only on Android and iOS.
  ///
  /// If this configuration is left null, then spell check is disabled by default.
  /// {@endtemplate}
  final ExtendedSpellCheckConfiguration? extendedSpellCheckConfiguration;

  /// zmtzawqlp
  /// [AdaptiveTextSelectionToolbar.editableText]
  static Widget _defaultContextMenuBuilder(
      BuildContext context, ExtendedEditableTextState editableTextState) {
    return AdaptiveTextSelectionToolbar.buttonItems(
      buttonItems: editableTextState.contextMenuButtonItems,
      anchors: editableTextState.contextMenuAnchors,
    );
    // return AdaptiveTextSelectionToolbar.editableText(
    //   editableTextState: editableTextState,
    // );
  }

  /// Returns a new [SpellCheckConfiguration] where the given configuration has
  /// had any missing values replaced with their defaults for the Android
  /// platform.
  static ExtendedSpellCheckConfiguration inferAndroidSpellCheckConfiguration(
    ExtendedSpellCheckConfiguration? configuration,
  ) {
    if (configuration == null ||
        configuration == const ExtendedSpellCheckConfiguration.disabled()) {
      return const ExtendedSpellCheckConfiguration.disabled();
    }
    return configuration.copyWith(
      misspelledTextStyle: configuration.misspelledTextStyle ??
          TextField.materialMisspelledTextStyle,
      extendedSpellCheckSuggestionsToolbarBuilder:
          configuration.extendedSpellCheckSuggestionsToolbarBuilder ??
              ExtendedTextField.defaultSpellCheckSuggestionsToolbarBuilder,
      // spellCheckSuggestionsToolbarBuilder:
      //     configuration.spellCheckSuggestionsToolbarBuilder ??
      //         TextField.defaultSpellCheckSuggestionsToolbarBuilder,
    ) as ExtendedSpellCheckConfiguration;
  }

  /// Default builder for [TextField]'s spell check suggestions toolbar.
  ///
  /// On Apple platforms, builds an iOS-style toolbar. Everywhere else, builds
  /// an Android-style toolbar.
  ///
  /// See also:
  ///  * [spellCheckConfiguration], where this is typically specified for
  ///    [TextField].
  ///  * [SpellCheckConfiguration.spellCheckSuggestionsToolbarBuilder], the
  ///    parameter for which this is the default value for [TextField].
  ///  * [CupertinoTextField.defaultSpellCheckSuggestionsToolbarBuilder], which
  ///    is like this but specifies the default for [CupertinoTextField].
  /// [TextField.defaultSpellCheckSuggestionsToolbarBuilder]
  @visibleForTesting
  static Widget defaultSpellCheckSuggestionsToolbarBuilder(
    BuildContext context,
    ExtendedEditableTextState editableTextState,
  ) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ExtendedCupertinoSpellCheckSuggestionsToolbar.editableText(
          editableTextState: editableTextState,
        );
      case TargetPlatform.android:
      case TargetPlatform.ohos:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return ExtendedSpellCheckSuggestionsToolbar.editableText(
          editableTextState: editableTextState,
        );
    }
  }

  /// Returns a new [SpellCheckConfiguration] where the given configuration has
  /// had any missing values replaced with their defaults for the iOS platform.
  static ExtendedSpellCheckConfiguration inferIOSSpellCheckConfiguration(
    ExtendedSpellCheckConfiguration? configuration,
  ) {
    if (configuration == null ||
        configuration == const ExtendedSpellCheckConfiguration.disabled()) {
      return const ExtendedSpellCheckConfiguration.disabled();
    }

    return configuration.copyWith(
      misspelledTextStyle: configuration.misspelledTextStyle ??
          CupertinoTextField.cupertinoMisspelledTextStyle,
      misspelledSelectionColor: configuration.misspelledSelectionColor ??
          // ignore: invalid_use_of_visible_for_testing_member
          CupertinoTextField.kMisspelledSelectionColor,
      extendedSpellCheckSuggestionsToolbarBuilder:
          configuration.extendedSpellCheckSuggestionsToolbarBuilder ??
              defaultIosSpellCheckSuggestionsToolbarBuilder,
      // spellCheckSuggestionsToolbarBuilder:
      //   configuration.spellCheckSuggestionsToolbarBuilder
      //     ?? CupertinoTextField.defaultSpellCheckSuggestionsToolbarBuilder,
    ) as ExtendedSpellCheckConfiguration;
  }

  /// Default builder for the spell check suggestions toolbar in the Cupertino
  /// style.
  ///
  /// See also:
  ///  * [spellCheckConfiguration], where this is typically specified for
  ///    [CupertinoTextField].
  ///  * [SpellCheckConfiguration.spellCheckSuggestionsToolbarBuilder], the
  ///    parameter for which this is the default value for [CupertinoTextField].
  ///  * [TextField.defaultSpellCheckSuggestionsToolbarBuilder], which is like
  ///    this but specifies the default for [CupertinoTextField].
  /// [CupertinoTextField.defaultSpellCheckSuggestionsToolbarBuilder]
  @visibleForTesting
  static Widget defaultIosSpellCheckSuggestionsToolbarBuilder(
    BuildContext context,
    ExtendedEditableTextState editableTextState,
  ) {
    return ExtendedCupertinoSpellCheckSuggestionsToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  @override
  State<_TextField> createState() {
    return ExtendedTextFieldState();
  }
}

class ExtendedTextFieldState extends _TextFieldState {
  ExtendedTextField get extenedTextField => widget as ExtendedTextField;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));
    assert(
      !(widget.style != null &&
          !widget.style!.inherit &&
          (widget.style!.fontSize == null ||
              widget.style!.textBaseline == null)),
      'inherit false style must supply fontSize and textBaseline',
    );

    final ThemeData theme = Theme.of(context);
    final DefaultSelectionStyle selectionStyle =
        DefaultSelectionStyle.of(context);
    final TextStyle? providedStyle =
        MaterialStateProperty.resolveAs(widget.style, _statesController.value);
    final TextStyle style = _getInputStyleForState(theme.useMaterial3
            ? _m3InputStyle(context)
            : theme.textTheme.titleMedium!)
        .merge(providedStyle);
    final Brightness keyboardAppearance =
        widget.keyboardAppearance ?? theme.brightness;
    final TextEditingController controller = _effectiveController;
    final FocusNode focusNode = _effectiveFocusNode;
    final List<TextInputFormatter> formatters = <TextInputFormatter>[
      ...?widget.inputFormatters,
      if (widget.maxLength != null)
        LengthLimitingTextInputFormatter(
          widget.maxLength,
          maxLengthEnforcement: _effectiveMaxLengthEnforcement,
        ),
    ];

    // Set configuration as disabled if not otherwise specified. If specified,
    // ensure that configuration uses the correct style for misspelled words for
    // the current platform, unless a custom style is specified.
    // zmtzawqlp
    final ExtendedSpellCheckConfiguration spellCheckConfiguration;
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        // zmtzawqlp
        spellCheckConfiguration =
            ExtendedTextField.inferIOSSpellCheckConfiguration(
          extenedTextField.extendedSpellCheckConfiguration,
        );
      case TargetPlatform.android:
      case TargetPlatform.ohos:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        // zmtzawqlp
        spellCheckConfiguration =
            ExtendedTextField.inferAndroidSpellCheckConfiguration(
          extenedTextField.extendedSpellCheckConfiguration,
        );
    }

    TextSelectionControls? textSelectionControls = widget.selectionControls;
    final bool paintCursorAboveText;
    bool? cursorOpacityAnimates = widget.cursorOpacityAnimates;
    Offset? cursorOffset;
    final Color cursorColor;
    final Color selectionColor;
    Color? autocorrectionTextRectColor;
    Radius? cursorRadius = widget.cursorRadius;
    VoidCallback? handleDidGainAccessibilityFocus;
    VoidCallback? handleDidLoseAccessibilityFocus;

    switch (theme.platform) {
      case TargetPlatform.iOS:
        final CupertinoThemeData cupertinoTheme = CupertinoTheme.of(context);
        forcePressEnabled = true;
        textSelectionControls ??= cupertinoTextSelectionHandleControls;
        paintCursorAboveText = true;
        cursorOpacityAnimates ??= true;
        cursorColor = _hasError
            ? _errorColor
            : widget.cursorColor ??
                selectionStyle.cursorColor ??
                cupertinoTheme.primaryColor;
        selectionColor = selectionStyle.selectionColor ??
            cupertinoTheme.primaryColor.withOpacity(0.40);
        cursorRadius ??= const Radius.circular(2.0);
        cursorOffset = Offset(
            iOSHorizontalOffset / MediaQuery.devicePixelRatioOf(context), 0);
        autocorrectionTextRectColor = selectionColor;

      case TargetPlatform.macOS:
        final CupertinoThemeData cupertinoTheme = CupertinoTheme.of(context);
        forcePressEnabled = false;
        textSelectionControls ??= cupertinoDesktopTextSelectionHandleControls;
        paintCursorAboveText = true;
        cursorOpacityAnimates ??= false;
        cursorColor = _hasError
            ? _errorColor
            : widget.cursorColor ??
                selectionStyle.cursorColor ??
                cupertinoTheme.primaryColor;
        selectionColor = selectionStyle.selectionColor ??
            cupertinoTheme.primaryColor.withOpacity(0.40);
        cursorRadius ??= const Radius.circular(2.0);
        cursorOffset = Offset(
            iOSHorizontalOffset / MediaQuery.devicePixelRatioOf(context), 0);
        handleDidGainAccessibilityFocus = () {
          // Automatically activate the TextField when it receives accessibility focus.
          if (!_effectiveFocusNode.hasFocus &&
              _effectiveFocusNode.canRequestFocus) {
            _effectiveFocusNode.requestFocus();
          }
        };
        handleDidLoseAccessibilityFocus = () {
          _effectiveFocusNode.unfocus();
        };

      case TargetPlatform.android:
      case TargetPlatform.ohos:
      case TargetPlatform.fuchsia:
        forcePressEnabled = false;
        textSelectionControls ??= materialTextSelectionHandleControls;
        paintCursorAboveText = false;
        cursorOpacityAnimates ??= false;
        cursorColor = _hasError
            ? _errorColor
            : widget.cursorColor ??
                selectionStyle.cursorColor ??
                theme.colorScheme.primary;
        selectionColor = selectionStyle.selectionColor ??
            theme.colorScheme.primary.withOpacity(0.40);

      case TargetPlatform.linux:
        forcePressEnabled = false;
        textSelectionControls ??= desktopTextSelectionHandleControls;
        paintCursorAboveText = false;
        cursorOpacityAnimates ??= false;
        cursorColor = _hasError
            ? _errorColor
            : widget.cursorColor ??
                selectionStyle.cursorColor ??
                theme.colorScheme.primary;
        selectionColor = selectionStyle.selectionColor ??
            theme.colorScheme.primary.withOpacity(0.40);
        handleDidGainAccessibilityFocus = () {
          // Automatically activate the TextField when it receives accessibility focus.
          if (!_effectiveFocusNode.hasFocus &&
              _effectiveFocusNode.canRequestFocus) {
            _effectiveFocusNode.requestFocus();
          }
        };
        handleDidLoseAccessibilityFocus = () {
          _effectiveFocusNode.unfocus();
        };

      case TargetPlatform.windows:
        forcePressEnabled = false;
        textSelectionControls ??= desktopTextSelectionHandleControls;
        paintCursorAboveText = false;
        cursorOpacityAnimates ??= false;
        cursorColor = _hasError
            ? _errorColor
            : widget.cursorColor ??
                selectionStyle.cursorColor ??
                theme.colorScheme.primary;
        selectionColor = selectionStyle.selectionColor ??
            theme.colorScheme.primary.withOpacity(0.40);
        handleDidGainAccessibilityFocus = () {
          // Automatically activate the TextField when it receives accessibility focus.
          if (!_effectiveFocusNode.hasFocus &&
              _effectiveFocusNode.canRequestFocus) {
            _effectiveFocusNode.requestFocus();
          }
        };
        handleDidLoseAccessibilityFocus = () {
          _effectiveFocusNode.unfocus();
        };
    }

    Widget child = RepaintBoundary(
      child: UnmanagedRestorationScope(
        bucket: bucket,
        child: ExtendedEditableText(
          key: editableTextKey,
          readOnly: widget.readOnly || !_isEnabled,
          toolbarOptions: widget.toolbarOptions,
          showCursor: widget.showCursor,
          showSelectionHandles: _showSelectionHandles,
          controller: controller,
          focusNode: focusNode,
          undoController: widget.undoController,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          style: style,
          strutStyle: widget.strutStyle,
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          autofocus: widget.autofocus,
          obscuringCharacter: widget.obscuringCharacter,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          smartDashesType: widget.smartDashesType,
          smartQuotesType: widget.smartQuotesType,
          enableSuggestions: widget.enableSuggestions,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          expands: widget.expands,
          // Only show the selection highlight when the text field is focused.
          selectionColor: focusNode.hasFocus ? selectionColor : null,
          selectionControls:
              widget.selectionEnabled ? textSelectionControls : null,
          onChanged: widget.onChanged,
          onSelectionChanged: _handleSelectionChanged,
          onEditingComplete: widget.onEditingComplete,
          onSubmitted: widget.onSubmitted,
          onAppPrivateCommand: widget.onAppPrivateCommand,
          groupId: widget.groupId,
          onSelectionHandleTapped: _handleSelectionHandleTapped,
          onTapOutside: widget.onTapOutside,
          inputFormatters: formatters,
          rendererIgnoresPointer: true,
          mouseCursor: MouseCursor.defer, // TextField will handle the cursor
          cursorWidth: widget.cursorWidth,
          cursorHeight: widget.cursorHeight,
          cursorRadius: cursorRadius,
          cursorColor: cursorColor,
          selectionHeightStyle: widget.selectionHeightStyle,
          selectionWidthStyle: widget.selectionWidthStyle,
          cursorOpacityAnimates: cursorOpacityAnimates,
          cursorOffset: cursorOffset,
          paintCursorAboveText: paintCursorAboveText,
          backgroundCursorColor: CupertinoColors.inactiveGray,
          scrollPadding: widget.scrollPadding,
          keyboardAppearance: keyboardAppearance,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          dragStartBehavior: widget.dragStartBehavior,
          scrollController: widget.scrollController,
          scrollPhysics: widget.scrollPhysics,
          autofillClient: this,
          autocorrectionTextRectColor: autocorrectionTextRectColor,
          clipBehavior: widget.clipBehavior,
          restorationId: 'editable',
          scribbleEnabled: widget.scribbleEnabled,
          enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
          contentInsertionConfiguration: widget.contentInsertionConfiguration,
          // contextMenuBuilder: widget.contextMenuBuilder,
          // spellCheckConfiguration: spellCheckConfiguration,
          extendedContextMenuBuilder:
              extenedTextField.extendedContextMenuBuilder,
          extendedSpellCheckConfiguration: spellCheckConfiguration,
          magnifierConfiguration: widget.magnifierConfiguration ??
              TextMagnifier.adaptiveMagnifierConfiguration,
          // zmtzawqlp
          specialTextSpanBuilder: extenedTextField.specialTextSpanBuilder,
        ),
      ),
    );

    if (widget.decoration != null) {
      child = AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[focusNode, controller]),
        builder: (BuildContext context, Widget? child) {
          return InputDecorator(
            decoration: _getEffectiveDecoration(),
            baseStyle: widget.style,
            textAlign: widget.textAlign,
            textAlignVertical: widget.textAlignVertical,
            isHovering: _isHovering,
            isFocused: focusNode.hasFocus,
            isEmpty: controller.value.text.isEmpty,
            expands: widget.expands,
            child: child,
          );
        },
        child: child,
      );
    }
    final MouseCursor effectiveMouseCursor =
        MaterialStateProperty.resolveAs<MouseCursor>(
      widget.mouseCursor ?? MaterialStateMouseCursor.textable,
      _statesController.value,
    );

    final int? semanticsMaxValueLength;
    if (_effectiveMaxLengthEnforcement != MaxLengthEnforcement.none &&
        widget.maxLength != null &&
        widget.maxLength! > 0) {
      semanticsMaxValueLength = widget.maxLength;
    } else {
      semanticsMaxValueLength = null;
    }

    return MouseRegion(
      cursor: effectiveMouseCursor,
      onEnter: (PointerEnterEvent event) => _handleHover(true),
      onExit: (PointerExitEvent event) => _handleHover(false),
      child: TextFieldTapRegion(
        child: IgnorePointer(
          ignoring: widget.ignorePointers ?? !_isEnabled,
          child: AnimatedBuilder(
            animation: controller, // changes the _currentLength
            builder: (BuildContext context, Widget? child) {
              return Semantics(
                enabled: _isEnabled,
                maxValueLength: semanticsMaxValueLength,
                currentValueLength: _currentLength,
                onTap: widget.readOnly
                    ? null
                    : () {
                        if (!_effectiveController.selection.isValid) {
                          _effectiveController.selection =
                              TextSelection.collapsed(
                                  offset: _effectiveController.text.length);
                        }
                        _requestKeyboard();
                      },
                onDidGainAccessibilityFocus: handleDidGainAccessibilityFocus,
                onDidLoseAccessibilityFocus: handleDidLoseAccessibilityFocus,
                onFocus: _isEnabled
                    ? () {
                        assert(
                            _effectiveFocusNode.canRequestFocus,
                            'Received SemanticsAction.focus from the engine. However, the FocusNode '
                            'of this text field cannot gain focus. This likely indicates a bug. '
                            'If this text field cannot be focused (e.g. because it is not '
                            'enabled), then its corresponding semantics node must be configured '
                            'such that the assistive technology cannot request focus on it.');

                        if (_effectiveFocusNode.canRequestFocus &&
                            !_effectiveFocusNode.hasFocus) {
                          _effectiveFocusNode.requestFocus();
                        } else if (!widget.readOnly) {
                          // If the platform requested focus, that means that previously the
                          // platform believed that the text field did not have focus (even
                          // though Flutter's widget system believed otherwise). This likely
                          // means that the on-screen keyboard is hidden, or more generally,
                          // there is no current editing session in this field. To correct
                          // that, keyboard must be requested.
                          //
                          // A concrete scenario where this can happen is when the user
                          // dismisses the keyboard on the web. The editing session is
                          // closed by the engine, but the text field widget stays focused
                          // in the framework.
                          _requestKeyboard();
                        }
                      }
                    : null,
                child: child,
              );
            },
            child: _selectionGestureDetectorBuilder.buildGestureDetector(
              behavior: HitTestBehavior.translucent,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  void bringIntoView(TextPosition position, {double offset = 0}) {
    (_editableText as ExtendedEditableTextState?)
        ?.bringIntoView(position, offset: offset);
  }
}
