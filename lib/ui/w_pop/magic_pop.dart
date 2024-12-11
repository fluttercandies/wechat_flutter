import 'package:flutter/material.dart';

import 'triangle_painter.dart';

const double _kMenuScreenPadding = 8.0;

class MagicPop extends StatefulWidget {
  MagicPop({
    required this.onValueChanged,
    required this.actions,
    required this.child,
    this.pressType = PressType.longPress,
    this.pageMaxChildCount = 5,
    this.backgroundColor = Colors.black,
    this.menuWidth = 250,
    this.menuHeight = 42,
  });

  final ValueChanged<int> onValueChanged;
  final List<String> actions;
  final Widget child;
  final PressType pressType;
  final int pageMaxChildCount;
  final Color backgroundColor;
  final double menuWidth;
  final double menuHeight;

  @override
  State<MagicPop> createState() => _WPopupMenuState();
}

class _WPopupMenuState extends State<MagicPop> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTap: () {
        if (widget.pressType == PressType.singleClick) {
          onTap();
        }
      },
      onLongPress: () {
        if (widget.pressType == PressType.longPress) {
          onTap();
        }
      },
    );
  }

  void onTap() {
    Navigator.push(
      context,
      _PopupMenuRoute(
        context,
        widget.actions,
        widget.pageMaxChildCount,
        widget.backgroundColor,
        widget.menuWidth,
        widget.menuHeight,
      ),
    ).then((index) {
      if (index != null && index is int) {
        widget.onValueChanged(index);
      }
    });
  }
}

enum PressType {
  longPress,
  singleClick,
}

class _PopupMenuRoute extends PopupRoute {
  _PopupMenuRoute(
    this.btnContext,
    this.actions,
    this._pageMaxChildCount,
    this.backgroundColor,
    this.menuWidth,
    this.menuHeight,
  )   : _height = btnContext.size!.height,
        _width = btnContext.size!.width;
  final BuildContext btnContext;
  final double _height;
  final double _width;
  final List<String> actions;
  final int _pageMaxChildCount;
  final Color backgroundColor;
  final double menuWidth;
  final double menuHeight;

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      reverseCurve: const Interval(0.0, 2.0 / 3.0),
    );
  }

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _MenuPopWidget(
      btnContext,
      _height,
      _width,
      actions,
      _pageMaxChildCount,
      backgroundColor,
      menuWidth,
      menuHeight,
    );
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);
}

class _MenuPopWidget extends StatefulWidget {
  _MenuPopWidget(
    this.btnContext,
    this._height,
    this._width,
    this.actions,
    this._pageMaxChildCount,
    this.backgroundColor,
    this.menuWidth,
    this.menuHeight,
  );

  final BuildContext btnContext;
  final double _height;
  final double _width;
  final List<String> actions;
  final int _pageMaxChildCount;
  final Color backgroundColor;
  final double menuWidth;
  final double menuHeight;

  @override
  __MenuPopWidgetState createState() => __MenuPopWidgetState();
}

class __MenuPopWidgetState extends State<_MenuPopWidget> {
  int _curPage = 0;
  final double _arrowWidth = 40;
  final double _separatorWidth = 1;
  final double _triangleHeight = 10;

  late RenderBox button;
  late RenderBox overlay;
  late RelativeRect position;

  @override
  void initState() {
    super.initState();
    button = widget.btnContext.findRenderObject() as RenderBox;
    overlay =
        Overlay.of(widget.btnContext)!.context.findRenderObject() as RenderBox;
    position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(Offset.zero, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    int _curPageChildCount =
        (_curPage + 1) * widget._pageMaxChildCount > widget.actions.length
            ? widget.actions.length % widget._pageMaxChildCount
            : widget._pageMaxChildCount;

    double _curArrowWidth = 0;
    int _curArrowCount = 0;

    if (widget.actions.length > widget._pageMaxChildCount) {
      if (_curPage == 0) {
        _curArrowWidth = _arrowWidth;
        _curArrowCount = 1;
      } else {
        _curArrowWidth = _arrowWidth * 2;
        _curArrowCount = 2;
      }
    }

    double _curPageWidth = widget.menuWidth +
        (_curPageChildCount - 1 + _curArrowCount) * _separatorWidth +
        _curArrowWidth;

    Widget view() {
      var isInverted = (position.top +
              (MediaQuery.of(context).size.height -
                      position.top -
                      position.bottom) /
                  2.0 -
              (widget.menuHeight + _triangleHeight)) <
          (widget.menuHeight + _triangleHeight) * 2;

      var pain = CustomPaint(
        size: Size(_curPageWidth, _triangleHeight),
        painter: TrianglePainter(
            color: widget.backgroundColor,
            position: position,
            isInverted: true,
            size: button.size),
      );

      var row = Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _curPage == 0
              ? Container(
                  height: widget.menuHeight,
                )
              : InkWell(
                  onTap: () {
                    setState(() {
                      _curPage--;
                    });
                  },
                  child: Container(
                    width: _arrowWidth,
                    height: widget.menuHeight,
                    child: Image.asset(
                      'images/left_white.png',
                      fit: BoxFit.none,
                    ),
                  ),
                ),
          _curPage == 0
              ? Container(
                  height: widget.menuHeight,
                )
              : Container(
                  width: 1,
                  height: widget.menuHeight,
                  color: Colors.grey,
                ),
          _buildList(_curPageChildCount, _curPageWidth, _curArrowWidth,
              _curArrowCount),
          _curArrowCount > 0
              ? Container(
                  width: 1,
                  color: Colors.grey,
                  height: widget.menuHeight,
                )
              : Container(
                  height: widget.menuHeight,
                ),
          _curArrowCount > 0
              ? InkWell(
                  onTap: () {
                    if ((_curPage + 1) * widget._pageMaxChildCount <
                        widget.actions.length)
                      setState(() {
                        _curPage++;
                      });
                  },
                  child: Container(
                    width: _arrowWidth,
                    height: widget.menuHeight,
                    child: Image.asset(
                      (_curPage + 1) * widget._pageMaxChildCount >=
                              widget.actions.length
                          ? 'images/right_gray.png'
                          : 'images/right_white.png',
                      fit: BoxFit.none,
                    ),
                  ),
                )
              : Container(
                  height: widget.menuHeight,
                ),
        ],
      );

      return Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            isInverted ? pain : Container(),
            Expanded(
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Container(
                      color: widget.backgroundColor,
                      height: widget.menuHeight,
                    ),
                  ),
                  row,
                ],
              ),
            ),
            isInverted
                ? Container()
                : CustomPaint(
                    size: Size(_curPageWidth, _triangleHeight),
                    painter: TrianglePainter(
                        color: widget.backgroundColor,
                        position: position,
                        size: button.size),
                  ),
          ],
        ),
      );
    }

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _PopupMenuRouteLayout(
                position,
                widget.menuHeight + _triangleHeight,
                Directionality.of(widget.btnContext),
                widget._width,
                widget.menuWidth),
            child: SizedBox(
                height: widget.menuHeight + _triangleHeight,
                width: _curPageWidth,
                child: view()),
          );
        },
      ),
    );
  }

  Widget _buildList(int _curPageChildCount, double _curPageWidth,
      double _curArrowWidth, int _curArrowCount) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: _curPageChildCount,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            Navigator.pop(
                context, _curPage * widget._pageMaxChildCount + index);
          },
          child: SizedBox(
            width: (_curPageWidth -
                    _curArrowWidth -
                    (_curPageChildCount - 1 + _curArrowCount) *
                        _separatorWidth) /
                _curPageChildCount,
            height: widget.menuHeight,
            child: Center(
              child: Text(
                widget.actions[_curPage * widget._pageMaxChildCount + index],
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          width: 1,
          height: widget.menuHeight,
          color: Colors.grey,
        );
      },
    );
  }
}

class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout(
    this.position,
    this.selectedItemOffset,
    this.textDirection,
    this.width,
    this.menuWidth,
  );

  final RelativeRect position;
  final double selectedItemOffset;
  final TextDirection textDirection;
  final double width;
  final double menuWidth;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(
      Size(
        constraints.biggest.width - (_kMenuScreenPadding * 2.0),
        constraints.biggest.height - (_kMenuScreenPadding * 2.0),
      ),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double y = position.top +
        (size.height - position.top - position.bottom) / 2.0 -
        selectedItemOffset;

    double x;
    if (position.left > position.right) {
      x = position.left + width - childSize.width;
    } else if (position.left < position.right) {
      if (width > childSize.width) {
        x = position.left + (childSize.width - menuWidth) / 2;
      } else {
        x = position.left;
      }
    } else {
      x = position.right - width / 2 - childSize.width / 2;
    }

    if (x < _kMenuScreenPadding)
      x = _kMenuScreenPadding;
    else if (x + childSize.width > size.width - _kMenuScreenPadding)
      x = size.width - childSize.width - _kMenuScreenPadding;
    if (y < _kMenuScreenPadding)
      y = _kMenuScreenPadding;
    else if (y + childSize.height > size.height - _kMenuScreenPadding)
      y = size.height - childSize.height;
    else if (y < childSize.height * 2) {
      y = position.top + childSize.height;
    }
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}
