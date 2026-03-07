part of 'package:extended_text_field/src/extended/widgets/text_field.dart';

/// Signature for a widget builder that builds a context menu for the given
/// [EditableTextState].
///
/// See also:
///
///  * [SelectableRegionContextMenuBuilder], which performs the same role for
///    [SelectableRegion].
typedef ExtendedEditableTextContextMenuBuilder = Widget Function(
  BuildContext context,
  ExtendedEditableTextState editableTextState,
);

/// [EditableText]
///
class ExtendedEditableText extends _EditableText {
  ExtendedEditableText({
    super.key,
    required super.controller,
    required super.focusNode,
    super.readOnly = false,
    super.obscuringCharacter = '•',
    super.obscureText = false,
    super.autocorrect = true,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions = true,
    required super.style,
    super.strutStyle,
    required super.cursorColor,
    required super.backgroundCursorColor,
    super.textAlign = TextAlign.start,
    super.textDirection,
    super.locale,
    super.textScaler,
    super.maxLines = 1,
    super.minLines,
    super.expands = false,
    super.forceLine = true,
    super.textHeightBehavior,
    super.textWidthBasis = TextWidthBasis.parent,
    super.autofocus = false,
    super.showCursor,
    super.showSelectionHandles = false,
    super.selectionColor,
    super.selectionControls,
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization = TextCapitalization.none,
    super.onChanged,
    super.onEditingComplete,
    super.onSubmitted,
    super.onAppPrivateCommand,
    super.onSelectionChanged,
    super.onSelectionHandleTapped,
    super.groupId = EditableText,
    super.onTapOutside,
    super.inputFormatters,
    super.mouseCursor,
    super.rendererIgnoresPointer = false,
    super.cursorWidth = 2.0,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorOpacityAnimates = false,
    super.cursorOffset,
    super.paintCursorAboveText = false,
    super.selectionHeightStyle = ui.BoxHeightStyle.tight,
    super.selectionWidthStyle = ui.BoxWidthStyle.tight,
    super.scrollPadding = const EdgeInsets.all(20.0),
    super.keyboardAppearance = Brightness.light,
    super.dragStartBehavior = DragStartBehavior.start,
    super.enableInteractiveSelection,
    super.scrollController,
    super.scrollPhysics,
    super.autocorrectionTextRectColor,
    @Deprecated(
      'Use `contextMenuBuilder` instead. '
      'This feature was deprecated after v3.3.0-0.5.pre.',
    )
    ToolbarOptions? toolbarOptions,
    super.autofillHints = const <String>[],
    super.autofillClient,
    super.clipBehavior = Clip.hardEdge,
    super.restorationId,
    super.scrollBehavior,
    super.scribbleEnabled = true,
    super.enableIMEPersonalizedLearning = true,
    super.contentInsertionConfiguration,
    // super.contextMenuBuilder,
    // super.spellCheckConfiguration,
    this.extendedContextMenuBuilder,
    this.extendedSpellCheckConfiguration,
    super.magnifierConfiguration = TextMagnifierConfiguration.disabled,
    super.undoController,
    this.specialTextSpanBuilder,
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
  @override
  _EditableTextState createState() {
    return ExtendedEditableTextState();
  }
}

class ExtendedEditableTextState extends _EditableTextState {
  ExtendedEditableText get extendedEditableText =>
      widget as ExtendedEditableText;
  ExtendedSpellCheckConfiguration get extendedSpellCheckConfiguration =>
      _spellCheckConfiguration as ExtendedSpellCheckConfiguration;

  /// whether to support build SpecialText
  bool get supportSpecialText =>
      extendedEditableText.specialTextSpanBuilder != null &&
      !widget.obscureText &&
      _textDirection == TextDirection.ltr;

  // State lifecycle:

  @override
  void initState() {
    super.initState();
    _spellCheckConfiguration = _inferSpellCheckConfiguration(
        extendedEditableText.extendedSpellCheckConfiguration);
  }

  /// Infers the [_SpellCheckConfiguration] used to perform spell check.
  ///
  /// If spell check is enabled, this will try to infer a value for
  /// the [SpellCheckService] if left unspecified.
  static _SpellCheckConfiguration _inferSpellCheckConfiguration(
      ExtendedSpellCheckConfiguration? configuration) {
    final SpellCheckService? spellCheckService =
        configuration?.spellCheckService;
    final bool spellCheckAutomaticallyDisabled = configuration == null ||
        configuration == const ExtendedSpellCheckConfiguration.disabled();
    final bool spellCheckServiceIsConfigured = spellCheckService != null ||
        spellCheckService == null &&
            WidgetsBinding
                .instance.platformDispatcher.nativeSpellCheckServiceDefined;
    if (spellCheckAutomaticallyDisabled || !spellCheckServiceIsConfigured) {
      // Only enable spell check if a non-disabled configuration is provided
      // and if that configuration does not specify a spell check service,
      // a native spell checker must be supported.
      assert(() {
        if (!spellCheckAutomaticallyDisabled &&
            !spellCheckServiceIsConfigured) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: FlutterError(
                'Spell check was enabled with spellCheckConfiguration, but the '
                'current platform does not have a supported spell check '
                'service, and none was provided. Consider disabling spell '
                'check for this platform or passing a SpellCheckConfiguration '
                'with a specified spell check service.',
              ),
              library: 'widget library',
              stack: StackTrace.current,
            ),
          );
        }
        return true;
      }());
      return const ExtendedSpellCheckConfiguration.disabled();
    }

    return configuration.copyWith(
        spellCheckService: spellCheckService ?? DefaultSpellCheckService());
  }

  // zmtzawqlp
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    super.build(context); // See AutomaticKeepAliveClientMixin.

    final TextSelectionControls? controls = widget.selectionControls;
    double? textScaleFactor;
    final TextScaler effectiveTextScaler = switch ((
      widget.textScaler, textScaleFactor //widget.textScaleFactor
    )) {
      (final TextScaler textScaler, _) => textScaler,
      (null, final double textScaleFactor) =>
        TextScaler.linear(textScaleFactor),
      (null, null) => MediaQuery.textScalerOf(context),
    };

    return _CompositionCallback(
      compositeCallback: _compositeCallback,
      enabled: _hasInputConnection,
      child: TextFieldTapRegion(
        groupId: widget.groupId,
        onTapOutside:
            _hasFocus ? widget.onTapOutside ?? _defaultOnTapOutside : null,
        debugLabel: kReleaseMode ? null : 'ExtendedEditableText',
        child: MouseRegion(
          cursor: widget.mouseCursor ?? SystemMouseCursors.text,
          child: Actions(
            actions: _actions,
            child: UndoHistory<TextEditingValue>(
              value: widget.controller,
              onTriggered: (TextEditingValue value) {
                userUpdateTextEditingValue(
                    value, SelectionChangedCause.keyboard);
              },
              shouldChangeUndoStack:
                  (TextEditingValue? oldValue, TextEditingValue newValue) {
                if (!newValue.selection.isValid) {
                  return false;
                }

                if (oldValue == null) {
                  return true;
                }

                switch (defaultTargetPlatform) {
                  case TargetPlatform.iOS:
                  case TargetPlatform.macOS:
                  case TargetPlatform.fuchsia:
                  case TargetPlatform.linux:
                  case TargetPlatform.windows:
                    // Composing text is not counted in history coalescing.
                    if (!widget.controller.value.composing.isCollapsed) {
                      return false;
                    }
                  case TargetPlatform.android:
                  case TargetPlatform.ohos:
                    // Gboard on Android puts non-CJK words in composing regions. Coalesce
                    // composing text in order to allow the saving of partial words in that
                    // case.
                    break;
                }

                return oldValue.text != newValue.text ||
                    oldValue.composing != newValue.composing;
              },
              undoStackModifier: (TextEditingValue value) {
                // On Android we should discard the composing region when pushing
                // a new entry to the undo stack. This prevents the TextInputPlugin
                // from restarting the input on every undo/redo when the composing
                // region is changed by the framework.
                return defaultTargetPlatform == TargetPlatform.android
                    ? value.copyWith(composing: TextRange.empty)
                    : value;
              },
              focusNode: widget.focusNode,
              controller: widget.undoController,
              child: Focus(
                focusNode: widget.focusNode,
                includeSemantics: false,
                debugLabel: kReleaseMode ? null : 'EditableText',
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    _handleContextMenuOnScroll(notification);
                    _scribbleCacheKey = null;
                    return false;
                  },
                  child: Scrollable(
                    key: _scrollableKey,
                    excludeFromSemantics: true,
                    axisDirection:
                        _isMultiline ? AxisDirection.down : AxisDirection.right,
                    controller: _scrollController,
                    physics: widget.scrollPhysics,
                    dragStartBehavior: widget.dragStartBehavior,
                    restorationId: widget.restorationId,
                    // If a ScrollBehavior is not provided, only apply scrollbars when
                    // multiline. The overscroll indicator should not be applied in
                    // either case, glowing or stretching.
                    scrollBehavior: widget.scrollBehavior ??
                        ScrollConfiguration.of(context).copyWith(
                          scrollbars: _isMultiline,
                          overscroll: false,
                        ),
                    viewportBuilder:
                        (BuildContext context, ViewportOffset offset) {
                      return CompositedTransformTarget(
                        link: _toolbarLayerLink,
                        child: Semantics(
                          onCopy: _semanticsOnCopy(controls),
                          onCut: _semanticsOnCut(controls),
                          onPaste: _semanticsOnPaste(controls),
                          child: _ScribbleFocusable(
                            focusNode: widget.focusNode,
                            editableKey: _editableKey,
                            enabled: widget.scribbleEnabled,
                            updateSelectionRects: () {
                              _openInputConnection();
                              _updateSelectionRects(force: true);
                            },
                            child: SizeChangedLayoutNotifier(
                              child: _ExtendedEditable(
                                key: _editableKey,
                                startHandleLayerLink: _startHandleLayerLink,
                                endHandleLayerLink: _endHandleLayerLink,
                                inlineSpan: buildTextSpan(),
                                value: _value,
                                cursorColor: _cursorColor,
                                backgroundCursorColor:
                                    widget.backgroundCursorColor,
                                showCursor: _cursorVisibilityNotifier,
                                forceLine: widget.forceLine,
                                readOnly: widget.readOnly,
                                hasFocus: _hasFocus,
                                maxLines: widget.maxLines,
                                minLines: widget.minLines,
                                expands: widget.expands,
                                strutStyle: widget.strutStyle,
                                selectionColor: _selectionOverlay
                                            ?.spellCheckToolbarIsVisible ??
                                        false
                                    ? _spellCheckConfiguration
                                            .misspelledSelectionColor ??
                                        widget.selectionColor
                                    : widget.selectionColor,
                                textScaler: effectiveTextScaler,
                                textAlign: widget.textAlign,
                                textDirection: _textDirection,
                                locale: widget.locale,
                                textHeightBehavior: widget.textHeightBehavior ??
                                    DefaultTextHeightBehavior.maybeOf(context),
                                textWidthBasis: widget.textWidthBasis,
                                obscuringCharacter: widget.obscuringCharacter,
                                obscureText: widget.obscureText,
                                offset: offset,
                                rendererIgnoresPointer:
                                    widget.rendererIgnoresPointer,
                                cursorWidth: widget.cursorWidth,
                                cursorHeight: widget.cursorHeight,
                                cursorRadius: widget.cursorRadius,
                                cursorOffset:
                                    widget.cursorOffset ?? Offset.zero,
                                selectionHeightStyle:
                                    widget.selectionHeightStyle,
                                selectionWidthStyle: widget.selectionWidthStyle,
                                paintCursorAboveText:
                                    widget.paintCursorAboveText,
                                enableInteractiveSelection:
                                    widget._userSelectionEnabled,
                                textSelectionDelegate: this,
                                devicePixelRatio: _devicePixelRatio,
                                promptRectRange: _currentPromptRectRange,
                                promptRectColor:
                                    widget.autocorrectionTextRectColor,
                                clipBehavior: widget.clipBehavior,
                                supportSpecialText: supportSpecialText,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Shows toolbar with spell check suggestions of misspelled words that are
  /// available for click-and-replace.
  @override
  bool showSpellCheckSuggestionsToolbar() {
    // Spell check suggestions toolbars are intended to be shown on non-web
    // platforms. Additionally, the Cupertino style toolbar can't be drawn on
    // the web with the HTML renderer due to
    // https://github.com/flutter/flutter/issues/123560.

    if (!spellCheckEnabled ||
        _webContextMenuEnabled ||
        widget.readOnly ||
        _selectionOverlay == null ||
        !_spellCheckResultsReceived ||
        findSuggestionSpanAtCursorIndex(
                textEditingValue.selection.extentOffset) ==
            null) {
      // Only attempt to show the spell check suggestions toolbar if there
      // is a toolbar specified and spell check suggestions available to show.
      return false;
    }

    assert(
      _spellCheckConfiguration.spellCheckSuggestionsToolbarBuilder != null,
      'spellCheckSuggestionsToolbarBuilder must be defined in '
      'SpellCheckConfiguration to show a toolbar with spell check '
      'suggestions',
    );

    // zmtzawqlp
    _selectionOverlay!.showSpellCheckSuggestionsToolbar(
      (BuildContext context) {
        // zmtzawqlp
        return extendedSpellCheckConfiguration
            .extendedSpellCheckSuggestionsToolbarBuilder!(
          context,
          this,
        );
      },
    );
    return true;
  }

  @override
  _TextSelectionOverlay _createSelectionOverlay() {
    final ExtendedTextSelectionOverlay selectionOverlay =
        ExtendedTextSelectionOverlay(
      clipboardStatus: clipboardStatus,
      context: context,
      value: _value,
      debugRequiredFor: widget,
      toolbarLayerLink: _toolbarLayerLink,
      startHandleLayerLink: _startHandleLayerLink,
      endHandleLayerLink: _endHandleLayerLink,
      renderObject: renderEditable,
      selectionControls: widget.selectionControls,
      selectionDelegate: this,
      dragStartBehavior: widget.dragStartBehavior,
      onSelectionHandleTapped: widget.onSelectionHandleTapped,
      // zmtzawqlp
      contextMenuBuilder:
          extendedEditableText.extendedContextMenuBuilder == null ||
                  _webContextMenuEnabled
              ? null
              : (BuildContext context) {
                  return extendedEditableText.extendedContextMenuBuilder!(
                    context,
                    this,
                  );
                },
      magnifierConfiguration: widget.magnifierConfiguration,
    );

    return selectionOverlay;
  }

  /// Builds [TextSpan] from current editing value.
  ///
  /// By default makes text in composing range appear as underlined.
  /// Descendants can override this method to customize appearance of text.
  @override
  TextSpan buildTextSpan() {
    if (widget.obscureText) {
      String text = _value.text;
      text = widget.obscuringCharacter * text.length;
      // Reveal the latest character in an obscured field only on mobile.
      // Newer versions of iOS (iOS 15+) no longer reveal the most recently
      // entered character.
      const Set<TargetPlatform> mobilePlatforms = <TargetPlatform>{
        TargetPlatform.android,
        TargetPlatform.fuchsia,
      };
      final bool brieflyShowPassword =
          WidgetsBinding.instance.platformDispatcher.brieflyShowPassword &&
              mobilePlatforms.contains(defaultTargetPlatform);
      if (brieflyShowPassword) {
        final int? o =
            _obscureShowCharTicksPending > 0 ? _obscureLatestCharIndex : null;
        if (o != null && o >= 0 && o < text.length) {
          text = text.replaceRange(o, o + 1, _value.text.substring(o, o + 1));
        }
      }
      return TextSpan(style: _style, text: text);
    }

    // zmtzawqlp
    if (_value.composing.isValid && !widget.readOnly) {
      final TextStyle composingStyle = widget.style.merge(
        const TextStyle(decoration: TextDecoration.underline),
      );
      final String beforeText = _value.composing.textBefore(_value.text);
      final String insideText = _value.composing.textInside(_value.text);
      final String afterText = _value.composing.textAfter(_value.text);

      if (supportSpecialText) {
        final TextSpan before = extendedEditableText.specialTextSpanBuilder!
            .build(beforeText, textStyle: widget.style);
        final TextSpan after = extendedEditableText.specialTextSpanBuilder!
            .build(afterText, textStyle: widget.style);

        final List<InlineSpan> children = <InlineSpan>[];

        children.add(before);

        children.add(TextSpan(
          style: composingStyle,
          text: insideText,
        ));

        children.add(after);

        return TextSpan(style: widget.style, children: children);
      }

      return TextSpan(style: widget.style, children: <TextSpan>[
        TextSpan(text: beforeText),
        TextSpan(
          style: composingStyle,
          text: insideText,
        ),
        TextSpan(text: afterText),
      ]);
    }

    if (supportSpecialText) {
      final TextSpan? specialTextSpan = extendedEditableText
          .specialTextSpanBuilder
          ?.build(_value.text, textStyle: widget.style);
      if (specialTextSpan != null) {
        return specialTextSpan;
      }
    }

    if (_placeholderLocation >= 0 &&
        _placeholderLocation <= _value.text.length) {
      final List<_ScribblePlaceholder> placeholders = <_ScribblePlaceholder>[];
      final int placeholderLocation = _value.text.length - _placeholderLocation;
      if (_isMultiline) {
        // The zero size placeholder here allows the line to break and keep the caret on the first line.
        placeholders.add(const _ScribblePlaceholder(
            child: SizedBox.shrink(), size: Size.zero));
        placeholders.add(_ScribblePlaceholder(
            child: const SizedBox.shrink(),
            size: Size(renderEditable.size.width, 0.0)));
      } else {
        placeholders.add(const _ScribblePlaceholder(
            child: SizedBox.shrink(), size: Size(100.0, 0.0)));
      }
      return TextSpan(
        style: _style,
        children: <InlineSpan>[
          TextSpan(text: _value.text.substring(0, placeholderLocation)),
          ...placeholders,
          TextSpan(text: _value.text.substring(placeholderLocation)),
        ],
      );
    }
    final bool withComposing = !widget.readOnly && _hasFocus;
    if (_spellCheckResultsReceived) {
      // If the composing range is out of range for the current text, ignore it to
      // preserve the tree integrity, otherwise in release mode a RangeError will
      // be thrown and this EditableText will be built with a broken subtree.
      assert(!_value.composing.isValid ||
          !withComposing ||
          _value.isComposingRangeValid);

      final bool composingRegionOutOfRange =
          !_value.isComposingRangeValid || !withComposing;

      return buildTextSpanWithSpellCheckSuggestions(
        _value,
        composingRegionOutOfRange,
        _style,
        _spellCheckConfiguration.misspelledTextStyle!,
        spellCheckResults!,
      );
    }

    // Read only mode should not paint text composing.
    return widget.controller.buildTextSpan(
      context: context,
      style: _style,
      withComposing: withComposing,
    );
  }

  @override
  void bringIntoView(TextPosition position, {double offset = 0}) {
    // zmtzawqlp
    if (supportSpecialText) {
      position =
          ExtendedTextLibraryUtils.convertTextInputPostionToTextPainterPostion(
        renderEditable.text!,
        position,
      );
    }
    final Rect localRect = renderEditable.getLocalRectForCaret(position);
    final RevealedOffset targetOffset = _getOffsetToRevealCaret(localRect);

    // zmtzawqlp
    _scrollController.jumpTo(targetOffset.offset + offset);
    renderEditable.showOnScreen(rect: targetOffset.rect);
  }

  ///zmt
  TextEditingValue _handleSpecialTextSpan(TextEditingValue value) {
    if (supportSpecialText) {
      final bool textChanged = _value.text != value.text;
      final bool selectionChanged = _value.selection != value.selection;
      if (textChanged) {
        final TextSpan newTextSpan = extendedEditableText
            .specialTextSpanBuilder!
            .build(value.text, textStyle: widget.style);

        final TextSpan oldTextSpan = extendedEditableText
            .specialTextSpanBuilder!
            .build(_value.text, textStyle: widget.style);
        value = ExtendedTextLibraryUtils.handleSpecialTextSpanDelete(
            value, _value, oldTextSpan, _textInputConnection);

        final String text = newTextSpan.toPlainText();
        //correct caret Offset
        //make sure caret is not in text when caretIn is false
        if (text != value.text || selectionChanged) {
          value = ExtendedTextLibraryUtils.correctCaretOffset(
            value,
            newTextSpan,
            _textInputConnection,
          );
        }
      } else if (selectionChanged) {
        final InlineSpan inlineSpan =
            (_editableKey.currentWidget as _ExtendedEditable).inlineSpan;

        value = ExtendedTextLibraryUtils.correctCaretOffset(
          value,
          inlineSpan,
          _textInputConnection,
          oldValue: _value,
        );
      }
    }

    return value;
  }

  @override
  void updateEditingValue(TextEditingValue value) {
    // This method handles text editing state updates from the platform text
    // input plugin. The [EditableText] may not have the focus or an open input
    // connection, as autofill can update a disconnected [EditableText].

    // Since we still have to support keyboard select, this is the best place
    // to disable text updating.
    if (!_shouldCreateInputConnection) {
      return;
    }

    if (_checkNeedsAdjustAffinity(value)) {
      value = value.copyWith(
          selection:
              value.selection.copyWith(affinity: _value.selection.affinity));
    }

    if (widget.readOnly) {
      // In the read-only case, we only care about selection changes, and reject
      // everything else.
      value = _value.copyWith(selection: value.selection);
    }
    _lastKnownRemoteTextEditingValue = value;
    // zmtzawqlp
    value = _handleSpecialTextSpan(value);
    if (value == _value) {
      // This is possible, for example, when the numeric keyboard is input,
      // the engine will notify twice for the same value.
      // Track at https://github.com/flutter/flutter/issues/65811
      return;
    }

    if (value.text == _value.text && value.composing == _value.composing) {
      // `selection` is the only change.
      SelectionChangedCause cause;
      if (_textInputConnection?.scribbleInProgress ?? false) {
        cause = SelectionChangedCause.scribble;
      } else if (_pointOffsetOrigin != null) {
        cause = SelectionChangedCause.forcePress;
      } else {
        cause = SelectionChangedCause.keyboard;
      }
      _handleSelectionChanged(value.selection, cause);
    } else {
      if (value.text != _value.text) {
        // Hide the toolbar if the text was changed, but only hide the toolbar
        // overlay; the selection handle's visibility will be handled
        // by `_handleSelectionChanged`. https://github.com/flutter/flutter/issues/108673
        hideToolbar(false);
      }
      _currentPromptRectRange = null;

      final bool revealObscuredInput = _hasInputConnection &&
          widget.obscureText &&
          WidgetsBinding.instance.platformDispatcher.brieflyShowPassword &&
          value.text.length == _value.text.length + 1;

      _obscureShowCharTicksPending =
          revealObscuredInput ? _kObscureShowLatestCharCursorTicks : 0;
      _obscureLatestCharIndex =
          revealObscuredInput ? _value.selection.baseOffset : null;
      _formatAndSetValue(value, SelectionChangedCause.keyboard);
    }

    // Wherever the value is changed by the user, schedule a showCaretOnScreen
    // to make sure the user can see the changes they just made. Programmatic
    // changes to `textEditingValue` do not trigger the behavior even if the
    // text field is focused.
    _scheduleShowCaretOnScreen(withAnimation: true);
    if (_hasInputConnection) {
      // To keep the cursor from blinking while typing, we want to restart the
      // cursor timer every time a new character is typed.
      _stopCursorBlink(resetCharTicks: false);
      _startCursorBlink();
    }
  }

  @override
  void userUpdateTextEditingValue(
      TextEditingValue value, SelectionChangedCause? cause) {
    // zmtzawqlp
    value = _handleSpecialTextSpan(value);
    // Compare the current TextEditingValue with the pre-format new
    // TextEditingValue value, in case the formatter would reject the change.
    final bool shouldShowCaret =
        widget.readOnly ? _value.selection != value.selection : _value != value;
    if (shouldShowCaret) {
      _scheduleShowCaretOnScreen(withAnimation: true);
    }

    // Even if the value doesn't change, it may be necessary to focus and build
    // the selection overlay. For example, this happens when right clicking an
    // unfocused field that previously had a selection in the same spot.
    if (value == textEditingValue) {
      if (!widget.focusNode.hasFocus) {
        _flagInternalFocus();
        widget.focusNode.requestFocus();
        _selectionOverlay ??= _createSelectionOverlay();
      }
      return;
    }

    _formatAndSetValue(value, cause, userInteraction: true);
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {
    _floatingCursorResetController ??= AnimationController(
      vsync: this,
    )..addListener(_onFloatingCursorResetTick);
    switch (point.state) {
      case FloatingCursorDragState.Start:
        if (_floatingCursorResetController!.isAnimating) {
          _floatingCursorResetController!.stop();
          _onFloatingCursorResetTick();
        }
        // Stop cursor blinking and making it visible.
        _stopCursorBlink(resetCharTicks: false);
        _cursorBlinkOpacityController.value = 1.0;
        // We want to send in points that are centered around a (0,0) origin, so
        // we cache the position.
        _pointOffsetOrigin = point.offset;

        final Offset startCaretCenter;
        final TextPosition currentTextPosition;
        final bool shouldResetOrigin;
        // Only non-null when starting a floating cursor via long press.
        if (point.startLocation != null) {
          shouldResetOrigin = false;
          (startCaretCenter, currentTextPosition) = point.startLocation!;
        } else {
          shouldResetOrigin = true;
          // zmtzawqlp
          currentTextPosition = supportSpecialText
              ? ExtendedTextLibraryUtils
                  .convertTextInputPostionToTextPainterPostion(
                  renderEditable.text!,
                  renderEditable.selection!.base,
                )
              : TextPosition(
                  offset: renderEditable.selection!.baseOffset,
                  affinity: renderEditable.selection!.affinity);
          startCaretCenter =
              renderEditable.getLocalRectForCaret(currentTextPosition).center;
        }

        _startCaretCenter = startCaretCenter;
        _lastBoundedOffset =
            renderEditable.calculateBoundedFloatingCursorOffset(
                _startCaretCenter! - _floatingCursorOffset,
                shouldResetOrigin: shouldResetOrigin);
        _lastTextPosition = currentTextPosition;
        renderEditable.setFloatingCursor(
            point.state, _lastBoundedOffset!, _lastTextPosition!);
      case FloatingCursorDragState.Update:
        final Offset centeredPoint = point.offset! - _pointOffsetOrigin!;
        final Offset rawCursorOffset =
            _startCaretCenter! + centeredPoint - _floatingCursorOffset;

        _lastBoundedOffset = renderEditable
            .calculateBoundedFloatingCursorOffset(rawCursorOffset);
        _lastTextPosition = renderEditable.getPositionForPoint(renderEditable
            .localToGlobal(_lastBoundedOffset! + _floatingCursorOffset));
        // zmtzawlp
        if (supportSpecialText) {
          _lastTextPosition =
              ExtendedTextLibraryUtils.makeSureCaretNotInSpecialText(
                  renderEditable.text!, _lastTextPosition!);
        }

        renderEditable.setFloatingCursor(
            point.state, _lastBoundedOffset!, _lastTextPosition!);
      case FloatingCursorDragState.End:
        // Resume cursor blinking.
        _startCursorBlink();
        // We skip animation if no update has happened.
        if (_lastTextPosition != null && _lastBoundedOffset != null) {
          _floatingCursorResetController!.value = 0.0;
          _floatingCursorResetController!.animateTo(1.0,
              // zmtzawqlp
              duration: _EditableTextState._floatingCursorResetTime,
              curve: Curves.decelerate);
        }
    }
  }

  @override
  void _scheduleShowCaretOnScreen({required bool withAnimation}) {
    if (_showCaretOnScreenScheduled) {
      return;
    }
    _showCaretOnScreenScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((Duration _) {
      _showCaretOnScreenScheduled = false;
      // Since we are in a post frame callback, check currentContext in case
      // RenderEditable has been disposed (in which case it will be null).
      final _RenderEditable? renderEditable =
          _editableKey.currentContext?.findRenderObject() as _RenderEditable?;
      if (renderEditable == null ||
          !(renderEditable.selection?.isValid ?? false) ||
          !_scrollController.hasClients) {
        return;
      }

      final double lineHeight = renderEditable.preferredLineHeight;

      // Enlarge the target rect by scrollPadding to ensure that caret is not
      // positioned directly at the edge after scrolling.
      double bottomSpacing = widget.scrollPadding.bottom;
      if (_selectionOverlay?.selectionControls != null) {
        final double handleHeight = _selectionOverlay!.selectionControls!
            .getHandleSize(lineHeight)
            .height;
        final double interactiveHandleHeight = math.max(
          handleHeight,
          kMinInteractiveDimension,
        );
        final Offset anchor =
            _selectionOverlay!.selectionControls!.getHandleAnchor(
          TextSelectionHandleType.collapsed,
          lineHeight,
        );
        final double handleCenter = handleHeight / 2 - anchor.dy;
        bottomSpacing = math.max(
          handleCenter + interactiveHandleHeight / 2,
          bottomSpacing,
        );
      }

      final EdgeInsets caretPadding =
          widget.scrollPadding.copyWith(bottom: bottomSpacing);

      final Rect caretRect = renderEditable.getLocalRectForCaret(
        // renderEditable.selection
        // zmtzawqlp
        (renderEditable as ExtendedRenderEditable).getActualSelection()!.extent,
      );
      final RevealedOffset targetOffset = _getOffsetToRevealCaret(caretRect);

      final Rect rectToReveal;
      final TextSelection selection = textEditingValue.selection;
      if (selection.isCollapsed) {
        rectToReveal = targetOffset.rect;
      } else {
        final List<TextBox> selectionBoxes =
            renderEditable.getBoxesForSelection(selection);
        // selectionBoxes may be empty if, for example, the selection does not
        // encompass a full character, like if it only contained part of an
        // extended grapheme cluster.
        if (selectionBoxes.isEmpty) {
          rectToReveal = targetOffset.rect;
        } else {
          rectToReveal = selection.baseOffset < selection.extentOffset
              ? selectionBoxes.last.toRect()
              : selectionBoxes.first.toRect();
        }
      }

      if (withAnimation) {
        _scrollController.animateTo(
          targetOffset.offset,
          duration: _EditableTextState._caretAnimationDuration,
          curve: _EditableTextState._caretAnimationCurve,
        );
        renderEditable.showOnScreen(
          rect: caretPadding.inflateRect(rectToReveal),
          duration: _EditableTextState._caretAnimationDuration,
          curve: _EditableTextState._caretAnimationCurve,
        );
      } else {
        _scrollController.jumpTo(targetOffset.offset);
        renderEditable.showOnScreen(
          rect: caretPadding.inflateRect(rectToReveal),
        );
      }
    });
  }

  @override
  void _updateCaretRectIfNeeded() {
    // zmtzawqlp
    final TextSelection? selection = // renderEditable.selection;
        (renderEditable as ExtendedRenderEditable).getActualSelection();
    if (selection == null || !selection.isValid || !selection.isCollapsed) {
      return;
    }
    final TextPosition currentTextPosition =
        TextPosition(offset: selection.start);
    final Rect caretRect =
        renderEditable.getLocalRectForCaret(currentTextPosition);
    _textInputConnection!.setCaretRect(caretRect);
  }
}

class _ExtendedEditable extends _Editable {
  _ExtendedEditable({
    super.key,
    required super.inlineSpan,
    required super.value,
    required super.startHandleLayerLink,
    required super.endHandleLayerLink,
    super.cursorColor,
    super.backgroundCursorColor,
    required super.showCursor,
    required super.forceLine,
    required super.readOnly,
    super.textHeightBehavior,
    required super.textWidthBasis,
    required super.hasFocus,
    required super.maxLines,
    super.minLines,
    required super.expands,
    super.strutStyle,
    super.selectionColor,
    required super.textScaler,
    required super.textAlign,
    required super.textDirection,
    super.locale,
    required super.obscuringCharacter,
    required super.obscureText,
    required super.offset,
    super.rendererIgnoresPointer = false,
    required super.cursorWidth,
    super.cursorHeight,
    super.cursorRadius,
    required super.cursorOffset,
    required super.paintCursorAboveText,
    super.selectionHeightStyle = ui.BoxHeightStyle.tight,
    super.selectionWidthStyle = ui.BoxWidthStyle.tight,
    super.enableInteractiveSelection = true,
    required super.textSelectionDelegate,
    required super.devicePixelRatio,
    super.promptRectRange,
    super.promptRectColor,
    required super.clipBehavior,
    this.supportSpecialText = false,
  });

  final bool supportSpecialText;

  @override
  ExtendedRenderEditable createRenderObject(BuildContext context) {
    return ExtendedRenderEditable(
      text: inlineSpan,
      cursorColor: cursorColor,
      startHandleLayerLink: startHandleLayerLink,
      endHandleLayerLink: endHandleLayerLink,
      backgroundCursorColor: backgroundCursorColor,
      showCursor: showCursor,
      forceLine: forceLine,
      readOnly: readOnly,
      hasFocus: hasFocus,
      maxLines: maxLines,
      minLines: minLines,
      expands: expands,
      strutStyle: strutStyle,
      selectionColor: selectionColor,
      textScaler: textScaler,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale ?? Localizations.maybeLocaleOf(context),
      selection: value.selection,
      offset: offset,
      ignorePointer: rendererIgnoresPointer,
      obscuringCharacter: obscuringCharacter,
      obscureText: obscureText,
      textHeightBehavior: textHeightBehavior,
      textWidthBasis: textWidthBasis,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorOffset: cursorOffset,
      paintCursorAboveText: paintCursorAboveText,
      selectionHeightStyle: selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle,
      enableInteractiveSelection: enableInteractiveSelection,
      textSelectionDelegate: textSelectionDelegate,
      devicePixelRatio: devicePixelRatio,
      promptRectRange: promptRectRange,
      promptRectColor: promptRectColor,
      clipBehavior: clipBehavior,
      supportSpecialText: supportSpecialText,
    );
  }

  // zmtzawqlp
  @override
  void updateRenderObject(BuildContext context, _RenderEditable renderObject) {
    super.updateRenderObject(context, renderObject);
    (renderObject as ExtendedRenderEditable).supportSpecialText =
        supportSpecialText;
  }
}
