part of 'package:extended_text_field/src/extended/widgets/text_field.dart';

/// [SelectableText]
class ExtendedSelectableText extends _SelectableText {
  const ExtendedSelectableText(
    super.data, {
    super.key,
    super.focusNode,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.textScaler,
    super.showCursor = false,
    super.autofocus = false,
    @Deprecated(
      'Use `contextMenuBuilder` instead. '
      'This feature was deprecated after v3.3.0-0.5.pre.',
    )
    super.toolbarOptions,
    super.minLines,
    super.maxLines,
    super.cursorWidth = 2.0,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorColor,
    super.selectionHeightStyle = ui.BoxHeightStyle.tight,
    super.selectionWidthStyle = ui.BoxWidthStyle.tight,
    super.dragStartBehavior = DragStartBehavior.start,
    super.enableInteractiveSelection = true,
    super.selectionControls,
    super.onTap,
    super.scrollPhysics,
    super.semanticsLabel,
    super.textHeightBehavior,
    super.textWidthBasis,
    super.onSelectionChanged,
    // super.contextMenuBuilder = _defaultContextMenuBuilder,
    this.extendedContextMenuBuilder =
        ExtendedTextField._defaultContextMenuBuilder,
    super.magnifierConfiguration,
    this.specialTextSpanBuilder,
  });

  const ExtendedSelectableText.rich(
    TextSpan textSpan, {
    super.key,
    super.focusNode,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.textScaler,
    super.showCursor = false,
    super.autofocus = false,
    @Deprecated(
      'Use `contextMenuBuilder` instead. '
      'This feature was deprecated after v3.3.0-0.5.pre.',
    )
    super.toolbarOptions,
    super.minLines,
    super.maxLines,
    super.cursorWidth = 2.0,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorColor,
    super.selectionHeightStyle = ui.BoxHeightStyle.tight,
    super.selectionWidthStyle = ui.BoxWidthStyle.tight,
    super.dragStartBehavior = DragStartBehavior.start,
    super.enableInteractiveSelection = true,
    super.selectionControls,
    super.onTap,
    super.scrollPhysics,
    super.semanticsLabel,
    super.textHeightBehavior,
    super.textWidthBasis,
    super.onSelectionChanged,
    // super.contextMenuBuilder = _defaultContextMenuBuilder,
    this.extendedContextMenuBuilder =
        ExtendedTextField._defaultContextMenuBuilder,
    super.magnifierConfiguration,
    this.specialTextSpanBuilder,
  }) : super.rich(textSpan);

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

  @override
  State<_SelectableText> createState() => _ExtendedSelectableTextState();
}

class _ExtendedSelectableTextState extends _SelectableTextState {
  ExtendedSelectableText get extendedSelectableText =>
      widget as ExtendedSelectableText;
  @override
  Widget build(BuildContext context) {
    // TODO(garyq): Assert to block WidgetSpans from being used here are removed,
    // but we still do not yet have nice handling of things like carets, clipboard,
    // and other features. We should add proper support. Currently, caret handling
    // is blocked on SkParagraph switch and https://github.com/flutter/engine/pull/27010
    // should be landed in SkParagraph after the switch is complete.
    assert(debugCheckHasMediaQuery(context));
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
    final FocusNode focusNode = _effectiveFocusNode;

    TextSelectionControls? textSelectionControls = widget.selectionControls;
    final bool paintCursorAboveText;
    final bool cursorOpacityAnimates;
    Offset? cursorOffset;
    final Color cursorColor;
    final Color selectionColor;
    Radius? cursorRadius = widget.cursorRadius;

    switch (theme.platform) {
      case TargetPlatform.iOS:
        final CupertinoThemeData cupertinoTheme = CupertinoTheme.of(context);
        forcePressEnabled = true;
        textSelectionControls ??= cupertinoTextSelectionHandleControls;
        paintCursorAboveText = true;
        cursorOpacityAnimates = true;
        cursorColor = widget.cursorColor ??
            selectionStyle.cursorColor ??
            cupertinoTheme.primaryColor;
        selectionColor = selectionStyle.selectionColor ??
            cupertinoTheme.primaryColor.withOpacity(0.40);
        cursorRadius ??= const Radius.circular(2.0);
        cursorOffset = Offset(
            iOSHorizontalOffset / MediaQuery.devicePixelRatioOf(context), 0);

      case TargetPlatform.macOS:
        final CupertinoThemeData cupertinoTheme = CupertinoTheme.of(context);
        forcePressEnabled = false;
        textSelectionControls ??= cupertinoDesktopTextSelectionHandleControls;
        paintCursorAboveText = true;
        cursorOpacityAnimates = true;
        cursorColor = widget.cursorColor ??
            selectionStyle.cursorColor ??
            cupertinoTheme.primaryColor;
        selectionColor = selectionStyle.selectionColor ??
            cupertinoTheme.primaryColor.withOpacity(0.40);
        cursorRadius ??= const Radius.circular(2.0);
        cursorOffset = Offset(
            iOSHorizontalOffset / MediaQuery.devicePixelRatioOf(context), 0);

      case TargetPlatform.android:
      case TargetPlatform.ohos:
      case TargetPlatform.fuchsia:
        forcePressEnabled = false;
        textSelectionControls ??= materialTextSelectionHandleControls;
        paintCursorAboveText = false;
        cursorOpacityAnimates = false;
        cursorColor = widget.cursorColor ??
            selectionStyle.cursorColor ??
            theme.colorScheme.primary;
        selectionColor = selectionStyle.selectionColor ??
            theme.colorScheme.primary.withOpacity(0.40);

      case TargetPlatform.linux:
      case TargetPlatform.windows:
        forcePressEnabled = false;
        textSelectionControls ??= desktopTextSelectionHandleControls;
        paintCursorAboveText = false;
        cursorOpacityAnimates = false;
        cursorColor = widget.cursorColor ??
            selectionStyle.cursorColor ??
            theme.colorScheme.primary;
        selectionColor = selectionStyle.selectionColor ??
            theme.colorScheme.primary.withOpacity(0.40);
    }

    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = widget.style;
    if (effectiveTextStyle == null || effectiveTextStyle.inherit) {
      effectiveTextStyle = defaultTextStyle.style
          .merge(widget.style ?? _controller._textSpan.style);
    }
    final Widget child = RepaintBoundary(
      // zmtzawqlp
      child: ExtendedEditableText(
        key: editableTextKey,
        style: effectiveTextStyle,
        readOnly: true,
        toolbarOptions: widget.toolbarOptions,
        textWidthBasis:
            widget.textWidthBasis ?? defaultTextStyle.textWidthBasis,
        textHeightBehavior:
            widget.textHeightBehavior ?? defaultTextStyle.textHeightBehavior,
        showSelectionHandles: _showSelectionHandles,
        showCursor: widget.showCursor,
        controller: _controller,
        focusNode: focusNode,
        strutStyle: widget.strutStyle ?? const StrutStyle(),
        textAlign:
            widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
        textDirection: widget.textDirection,
        textScaler: widget.textScaler,
        autofocus: widget.autofocus,
        forceLine: false,
        minLines: widget.minLines,
        maxLines: widget.maxLines ?? defaultTextStyle.maxLines,
        selectionColor: selectionColor,
        selectionControls:
            widget.selectionEnabled ? textSelectionControls : null,
        onSelectionChanged: _handleSelectionChanged,
        onSelectionHandleTapped: _handleSelectionHandleTapped,
        rendererIgnoresPointer: true,
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
        enableInteractiveSelection: widget.enableInteractiveSelection,
        magnifierConfiguration: widget.magnifierConfiguration ??
            TextMagnifier.adaptiveMagnifierConfiguration,
        dragStartBehavior: widget.dragStartBehavior,
        scrollPhysics: widget.scrollPhysics,
        autofillHints: null,
        // zmtzawqlp
        // contextMenuBuilder: widget.contextMenuBuilder,
        extendedContextMenuBuilder:
            extendedSelectableText.extendedContextMenuBuilder,
        specialTextSpanBuilder: extendedSelectableText.specialTextSpanBuilder,
      ),
    );

    return Semantics(
      label: widget.semanticsLabel,
      excludeSemantics: widget.semanticsLabel != null,
      onLongPress: () {
        _effectiveFocusNode.requestFocus();
      },
      child: _selectionGestureDetectorBuilder.buildGestureDetector(
        behavior: HitTestBehavior.translucent,
        child: child,
      ),
    );
  }
}
