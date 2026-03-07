part of 'package:extended_text_field/src/extended/widgets/text_field.dart';

/// [TextSelectionOverlay ]
class ExtendedTextSelectionOverlay extends _TextSelectionOverlay {
  ExtendedTextSelectionOverlay({
    required super.value,
    required super.context,
    super.debugRequiredFor,
    required super.toolbarLayerLink,
    required super.startHandleLayerLink,
    required super.endHandleLayerLink,
    required super.renderObject,
    super.selectionControls,
    super.handlesVisible = false,
    required super.selectionDelegate,
    super.dragStartBehavior = DragStartBehavior.start,
    super.onSelectionHandleTapped,
    super.clipboardStatus,
    super.contextMenuBuilder,
    required super.magnifierConfiguration,
  });

  @override
  void _handleSelectionStartHandleDragUpdate(DragUpdateDetails details) {
    if (!renderObject.attached) {
      return;
    }

    // This is NOT the same as details.localPosition. That is relative to the
    // selection handle, whereas this is relative to the RenderEditable.
    final Offset localPosition =
        renderObject.globalToLocal(details.globalPosition);
    final double nextStartHandleDragPositionLocal = _getHandleDy(
      localPosition.dy,
      renderObject.globalToLocal(Offset(0.0, _startHandleDragPosition)).dy,
    );
    _startHandleDragPosition = renderObject
        .localToGlobal(
          Offset(0.0, nextStartHandleDragPositionLocal),
        )
        .dy;
    final Offset handleTargetGlobal = Offset(
      details.globalPosition.dx,
      _startHandleDragPosition + _startHandleDragTarget,
    );
    TextPosition position =
        renderObject.getPositionForPoint(handleTargetGlobal);

    /// zmtzawqlp
    final bool hasSpecialInlineSpanBase =
        (renderObject as ExtendedRenderEditable).hasSpecialInlineSpanBase;
    if (hasSpecialInlineSpanBase) {
      position =
          ExtendedTextLibraryUtils.convertTextPainterPostionToTextInputPostion(
              renderObject.text!, position)!;
    }
    if (_selection.isCollapsed) {
      _selectionOverlay.updateMagnifier(_buildMagnifier(
        currentTextPosition: position,
        globalGesturePosition: details.globalPosition,
        renderEditable: renderObject,
        hasSpecialInlineSpanBase: hasSpecialInlineSpanBase,
      ));

      final TextSelection currentSelection =
          TextSelection.fromPosition(position);
      _handleSelectionHandleChanged(currentSelection);
      return;
    }

    final TextSelection newSelection;
    switch (defaultTargetPlatform) {
      // On Apple platforms, dragging the base handle makes it the extent.
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        newSelection = TextSelection(
          extentOffset: position.offset,
          baseOffset: _selection.end,
        );
        if (newSelection.extentOffset >= _selection.end) {
          return; // Don't allow order swapping.
        }
      case TargetPlatform.android:
      case TargetPlatform.ohos:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        newSelection = TextSelection(
          baseOffset: position.offset,
          extentOffset: _selection.extentOffset,
        );
        if (newSelection.baseOffset >= newSelection.extentOffset) {
          return; // Don't allow order swapping.
        }
    }

    _selectionOverlay.updateMagnifier(_buildMagnifier(
      currentTextPosition: newSelection.extent.offset < newSelection.base.offset
          ? newSelection.extent
          : newSelection.base,
      globalGesturePosition: details.globalPosition,
      renderEditable: renderObject,
      hasSpecialInlineSpanBase: hasSpecialInlineSpanBase,
    ));

    _handleSelectionHandleChanged(newSelection);
  }

  @override
  void _handleSelectionEndHandleDragUpdate(DragUpdateDetails details) {
    if (!renderObject.attached) {
      return;
    }

    // This is NOT the same as details.localPosition. That is relative to the
    // selection handle, whereas this is relative to the RenderEditable.
    final Offset localPosition =
        renderObject.globalToLocal(details.globalPosition);

    final double nextEndHandleDragPositionLocal = _getHandleDy(
      localPosition.dy,
      renderObject.globalToLocal(Offset(0.0, _endHandleDragPosition)).dy,
    );
    _endHandleDragPosition = renderObject
        .localToGlobal(
          Offset(0.0, nextEndHandleDragPositionLocal),
        )
        .dy;

    final Offset handleTargetGlobal = Offset(
      details.globalPosition.dx,
      _endHandleDragPosition + _endHandleDragTarget,
    );

    TextPosition position =
        renderObject.getPositionForPoint(handleTargetGlobal);
    // zmtzawqlp
    final bool hasSpecialInlineSpanBase =
        (renderObject as ExtendedRenderEditable).hasSpecialInlineSpanBase;
    if (hasSpecialInlineSpanBase) {
      position =
          ExtendedTextLibraryUtils.convertTextPainterPostionToTextInputPostion(
              renderObject.text!, position)!;
    }
    if (_selection.isCollapsed) {
      _selectionOverlay.updateMagnifier(_buildMagnifier(
        currentTextPosition: position,
        globalGesturePosition: details.globalPosition,
        renderEditable: renderObject,
        hasSpecialInlineSpanBase: hasSpecialInlineSpanBase,
      ));

      final TextSelection currentSelection =
          TextSelection.fromPosition(position);
      _handleSelectionHandleChanged(currentSelection);
      return;
    }

    final TextSelection newSelection;
    switch (defaultTargetPlatform) {
      // On Apple platforms, dragging the base handle makes it the extent.
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        newSelection = TextSelection(
          extentOffset: position.offset,
          baseOffset: _selection.start,
        );
        if (position.offset <= _selection.start) {
          return; // Don't allow order swapping.
        }
      case TargetPlatform.android:
      case TargetPlatform.ohos:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        newSelection = TextSelection(
          baseOffset: _selection.baseOffset,
          extentOffset: position.offset,
        );
        if (newSelection.baseOffset >= newSelection.extentOffset) {
          return; // Don't allow order swapping.
        }
    }

    _handleSelectionHandleChanged(newSelection);

    _selectionOverlay.updateMagnifier(_buildMagnifier(
      currentTextPosition: newSelection.extent,
      globalGesturePosition: details.globalPosition,
      renderEditable: renderObject,
      hasSpecialInlineSpanBase: hasSpecialInlineSpanBase,
    ));
  }

  @override
  MagnifierInfo _buildMagnifier({
    required _RenderEditable renderEditable,
    required ui.Offset globalGesturePosition,
    required ui.TextPosition currentTextPosition,
    bool hasSpecialInlineSpanBase = false,
  }) {
    // zmtzawqlp
    if (hasSpecialInlineSpanBase) {
      currentTextPosition =
          ExtendedTextLibraryUtils.convertTextInputPostionToTextPainterPostion(
              renderObject.text!, currentTextPosition);
    }
    return super._buildMagnifier(
        renderEditable: renderEditable,
        globalGesturePosition: globalGesturePosition,
        currentTextPosition: currentTextPosition);
  }

  // @override
  // void _handleSelectionHandleChanged(TextSelection newSelection) {
  //   // zmtzawqlp
  //   if ((renderObject as ExtendedRenderEditable).hasSpecialInlineSpanBase) {
  //     newSelection = ExtendedTextLibraryUtils
  //         .convertTextPainterSelectionToTextInputSelection(
  //             renderObject.text!, newSelection);
  //   }
  //   super._handleSelectionHandleChanged(newSelection);
  // }
}
