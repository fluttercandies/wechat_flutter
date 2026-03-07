part of 'package:extended_text_field/src/extended/widgets/text_field.dart';

/// [RenderEditable]
class ExtendedRenderEditable extends _RenderEditable {
  ExtendedRenderEditable({
    super.text,
    required super.textDirection,
    super.textAlign = TextAlign.start,
    super.cursorColor,
    super.backgroundCursorColor,
    super.showCursor,
    super.hasFocus,
    required super.startHandleLayerLink,
    required super.endHandleLayerLink,
    super.maxLines = 1,
    super.minLines,
    super.expands = false,
    super.strutStyle,
    super.selectionColor,
    super.textScaler = TextScaler.noScaling,
    super.selection,
    required super.offset,
    super.ignorePointer = false,
    super.readOnly = false,
    super.forceLine = true,
    super.textHeightBehavior,
    super.textWidthBasis = TextWidthBasis.parent,
    super.obscuringCharacter = '•',
    super.obscureText = false,
    super.locale,
    super.cursorWidth = 1.0,
    super.cursorHeight,
    super.cursorRadius,
    super.paintCursorAboveText = false,
    super.cursorOffset = Offset.zero,
    super.devicePixelRatio = 1.0,
    super.selectionHeightStyle = ui.BoxHeightStyle.tight,
    super.selectionWidthStyle = ui.BoxWidthStyle.tight,
    super.enableInteractiveSelection,
    super.floatingCursorAddedMargin = const EdgeInsets.fromLTRB(4, 4, 4, 5),
    super.promptRectRange,
    super.promptRectColor,
    super.clipBehavior = Clip.hardEdge,
    required super.textSelectionDelegate,
    super.painter,
    super.foregroundPainter,
    super.children,
    this.supportSpecialText = false,
  }) {
    _findSpecialInlineSpanBase(text);
  }

  bool supportSpecialText = false;
  bool _hasSpecialInlineSpanBase = false;
  bool get hasSpecialInlineSpanBase =>
      supportSpecialText && _hasSpecialInlineSpanBase;

  void _findSpecialInlineSpanBase(InlineSpan? span) {
    _hasSpecialInlineSpanBase = false;
    span?.visitChildren((InlineSpan span) {
      if (span is SpecialInlineSpanBase) {
        _hasSpecialInlineSpanBase = true;
        return false;
      }
      return true;
    });
  }

  @override
  set text(InlineSpan? value) {
    if (_textPainter.text == value) {
      return;
    }
    _findSpecialInlineSpanBase(value);
    super.text = value;
  }

  @override
  String get plainText {
    return ExtendedTextLibraryUtils.textSpanToActualText(_textPainter.text!);
  }

  /// Move the selection to the beginning or end of a word.
  ///
  /// {@macro flutter.rendering.RenderEditable.selectPosition}
  @override
  void selectWordEdge({required SelectionChangedCause cause}) {
    _computeTextMetricsIfNeeded();
    assert(_lastTapDownPosition != null);
    final TextPosition position = _textPainter.getPositionForOffset(
        globalToLocal(_lastTapDownPosition!) - _paintOffset);
    final TextRange word = _textPainter.getWordBoundary(position);
    late TextSelection newSelection;
    if (position.offset <= word.start) {
      newSelection = TextSelection.collapsed(offset: word.start);
    } else {
      newSelection = TextSelection.collapsed(
          offset: word.end, affinity: TextAffinity.upstream);
    }

    /// zmtzawqlp
    newSelection = hasSpecialInlineSpanBase
        ? ExtendedTextLibraryUtils
            .convertTextPainterSelectionToTextInputSelection(
                text!, newSelection)
        : newSelection;
    _setSelection(newSelection, cause);
  }

  @override

  /// Select text between the global positions [from] and [to].
  ///
  /// [from] corresponds to the [TextSelection.baseOffset], and [to] corresponds
  /// to the [TextSelection.extentOffset].
  void selectPositionAt(
      {required Offset from,
      Offset? to,
      required SelectionChangedCause cause}) {
    _computeTextMetricsIfNeeded();
    TextPosition fromPosition =
        _textPainter.getPositionForOffset(globalToLocal(from) - _paintOffset);
    TextPosition? toPosition = to == null
        ? null
        : _textPainter.getPositionForOffset(globalToLocal(to) - _paintOffset);
    // zmtzawqlp
    if (hasSpecialInlineSpanBase) {
      fromPosition =
          ExtendedTextLibraryUtils.convertTextPainterPostionToTextInputPostion(
              text!, fromPosition)!;
      toPosition =
          ExtendedTextLibraryUtils.convertTextPainterPostionToTextInputPostion(
              text!, toPosition);
    }
    final int baseOffset = fromPosition.offset;
    final int extentOffset = toPosition?.offset ?? fromPosition.offset;

    final TextSelection newSelection = TextSelection(
      baseOffset: baseOffset,
      extentOffset: extentOffset,
      affinity: fromPosition.affinity,
    );

    _setSelection(newSelection, cause);
  }

  @override
  TextSelection getWordAtOffset(TextPosition position) {
    final TextSelection selection = super.getWordAtOffset(position);

    /// zmt
    return hasSpecialInlineSpanBase
        ? ExtendedTextLibraryUtils
            .convertTextPainterSelectionToTextInputSelection(text!, selection,
                selectWord: true)
        : selection;
  }

  @override
  List<TextSelectionPoint> getEndpointsForSelection(TextSelection selection) {
    // zmtzawqlp
    if (hasSpecialInlineSpanBase) {
      selection = ExtendedTextLibraryUtils
          .convertTextInputSelectionToTextPainterSelection(text!, selection);
    }

    return super.getEndpointsForSelection(selection);
  }

  @override
  set selection(TextSelection? value) {
    if (_selection == value) {
      return;
    }
    _selection = value;
    _selectionPainter.highlightedRange = getActualSelection();
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  @override
  void setPromptRectRange(TextRange? newRange) {
    _autocorrectHighlightPainter.highlightedRange =
        getActualSelection(newRange: newRange);
  }

  TextSelection? getActualSelection({TextRange? newRange}) {
    TextSelection? value = selection;
    if (newRange != null) {
      value =
          TextSelection(baseOffset: newRange.start, extentOffset: newRange.end);
    }

    return hasSpecialInlineSpanBase
        ? ExtendedTextLibraryUtils
            .convertTextInputSelectionToTextPainterSelection(text!, value!)
        : value;
  }
}
