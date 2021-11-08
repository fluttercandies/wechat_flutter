import 'package:flutter/material.dart';
import 'package:wechat_flutter/config/const.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/w_pop/popup_menu_route_layout.dart';
import 'triangle_painter.dart';

class MenuPopWidget extends StatefulWidget {
  final BuildContext btnContext;
  final double _height;
  final double _width;
  final List actions;
  final int _pageMaxChildCount;
  final Color backgroundColor;
  final double menuWidth;
  final double menuHeight;
  final EdgeInsets padding;
  final EdgeInsets margin;

  MenuPopWidget(
    this.btnContext,
    this._height,
    this._width,
    this.actions,
    this._pageMaxChildCount,
    this.backgroundColor,
    this.menuWidth,
    this.menuHeight,
    this.padding,
    this.margin,
  );

  @override
  _MenuPopWidgetState createState() => _MenuPopWidgetState();
}

class _MenuPopWidgetState extends State<MenuPopWidget> {
  int _curPage = 0;
  final double _separatorWidth = 1;
  final double _triangleHeight = 10;
  bool isShow = true;

  Color itemColor = itemBgColor;

  RenderBox button;
  RenderBox overlay;
  RelativeRect position;

  @override
  void initState() {
    super.initState();
    button = widget.btnContext.findRenderObject();
    overlay = Overlay.of(widget.btnContext).context.findRenderObject();
    position = new RelativeRect.fromRect(
      new Rect.fromPoints(
        button.localToGlobal(Offset(-10, 100), ancestor: overlay),
        button.localToGlobal(Offset(-10, 0), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(builder: (BuildContext context) {
        return new CustomSingleChildLayout(
          // 这里计算偏移量
          delegate: new PopupMenuRouteLayout(
              position,
              null,
              Directionality.of(widget.btnContext),
              widget._width,
              widget.menuWidth,
              widget._height),
          child: contentBuild(),
        );
      }),
    );
  }

  Widget body(width) {
    return new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      new Visibility(
        visible: isShow,
        child: new CustomPaint(
          size: Size(width, _triangleHeight),
          painter: new TrianglePainter(
            color: itemBgColor,
            position: position,
            isInverted: true,
            size: button.size,
            screenWidth: MediaQuery.of(context).size.width,
          ),
        ),
      ),
      new Visibility(
        visible: isShow,
        child: new Expanded(
          child: Stack(children: <Widget>[
            new ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: Container(color: itemBgColor, height: widget.menuHeight),
            ),
            new Column(
              children: widget.actions.map(itemBuild).toList(),
            ),
          ]),
        ),
      ),
    ]);
  }

  Widget contentBuild() {
    // 这里计算出来 当前页的 child 一共有多少个
    int _curPageChildCount =
        (_curPage + 1) * widget._pageMaxChildCount > widget.actions.length
            ? widget.actions.length % widget._pageMaxChildCount
            : widget._pageMaxChildCount;

    double _curArrowWidth = 0;
    int _curArrowCount = 0; // 一共几个箭头
    double _curPageWidth = widget.menuWidth +
        (_curPageChildCount - 1 + _curArrowCount) * _separatorWidth +
        _curArrowWidth;
    return SizedBox(
      height: widget.menuHeight + _triangleHeight,
      width: _curPageWidth,
      child:
          new Material(color: Colors.transparent, child: body(_curPageWidth)),
    );
  }

  Widget itemBuild(item) {
    var row = [
      new Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: strNoEmpty(item['icon'])
            ? new Image.asset(item['icon'])
            : new Icon(Icons.phone, color: Colors.white),
      ),
      new Expanded(
        child: new Container(
          height: 50,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              border: item['title'] == widget.actions[0]['title']
                  ? null
                  : Border(
                      top: BorderSide(
                          color: Colors.white.withOpacity(0.3), width: 0.2))),
          child: new Text(
            item['title'],
            style: TextStyle(color: Colors.white),
          ),
        ),
      )
    ];
    return new FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        isShow = false;
        setState(() {});
        Navigator.of(context).pop(item['title']);
      },
      child: new Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        padding: EdgeInsets.only(left: 10.0),
        child: new Row(children: row),
      ),
    );
  }
}
