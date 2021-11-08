import 'package:flutter/material.dart';

const double _kBaselineOffsetFromBottom = 20.0;
const double _kMenuHorizontalPadding = 16.0;
const double _kMenuItemHeight = 48.0;

class MyPopupMenuItem<T> extends PopupMenuEntry<T> {
  final T value;
  final bool enabled;
  @override
  final double height;
  final Widget child;

  const MyPopupMenuItem(
      {this.value,
      this.enabled = true,
      this.height = _kMenuItemHeight,
      @required this.child});

  @override
  bool represents(T value) => value == this.value;

  @override
  PopupMenuItemState<T, MyPopupMenuItem<T>> createState() =>
      PopupMenuItemState<T, MyPopupMenuItem<T>>();
}

class PopupMenuItemState<T, W extends MyPopupMenuItem<T>> extends State<W> {
  @protected
  Widget buildChild() => widget.child;

  @protected
  void handleTap() {
    Navigator.pop<T>(context, widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    /// 适配flutter2.5.2
    TextStyle style = theme.textTheme.subtitle1;
    if (!widget.enabled) style = style.copyWith(color: theme.disabledColor);

    Widget item = AnimatedDefaultTextStyle(
      style: style,
      duration: Duration(milliseconds: 20),
      child: Baseline(
        baseline: widget.height - _kBaselineOffsetFromBottom,
        baselineType: style.textBaseline,
        child: buildChild(),
      ),
    );
    if (!widget.enabled) {
      final bool isDark = theme.brightness == Brightness.dark;
      item = IconTheme.merge(
        data: IconThemeData(opacity: isDark ? 0.5 : 0.38),
        child: item,
      );
    }

    return InkWell(
      onTap: widget.enabled ? handleTap : null,
      child: Container(
        height: widget.height,
        width: 165.0,
        alignment: Alignment.centerLeft,
        padding:
            const EdgeInsets.symmetric(horizontal: _kMenuHorizontalPadding),
        child: item,
      ),
    );
  }
}
