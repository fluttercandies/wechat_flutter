import 'package:flutter/material.dart';
import 'package:wechat_flutter/config/const.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/w_pop/popup_menu_route_layout.dart';
import 'triangle_painter.dart';

class MenuPopWidget extends StatefulWidget {
  final BuildContext btnContext;
  final double height;
  final double width;
  final List<Map<String, String>> actions;
  final int pageMaxChildCount;
  final Color backgroundColor;
  final double menuWidth;
  final double menuHeight;
  final EdgeInsets padding;
  final EdgeInsets margin;

  MenuPopWidget({
    required this.btnContext,
    required this.height,
    required this.width,
    required this.actions,
    required this.pageMaxChildCount,
    required this.backgroundColor,
    required this.menuWidth,
    required this.menuHeight,
    required this.padding,
    required this.margin,
  });

  @override
  _MenuPopWidgetState createState() => _MenuPopWidgetState();
}

class _MenuPopWidgetState extends State<MenuPopWidget> {
  int _curPage = 0;
  final double _separatorWidth = 1;
  final double _triangleHeight = 10;
  bool isShow = true;

  Color itemColor = itemBgColor;

  late RenderBox button;
  late RenderBox overlay;
  late RelativeRect position;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      button = widget.btnContext.findRenderObject() as RenderBox;
      overlay = Overlay.of(widget.btnContext)!.context.findRenderObject() as RenderBox;
      position = RelativeRect.fromRect(
        Rect.fromPoints(
          button.localToGlobal(Offset(-10, 100), ancestor: overlay),
          button.localToGlobal(Offset(-10, 0), ancestor: overlay),
        ),
        Offset.zero & overlay.size,
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(builder: (BuildContext context) {
        return CustomSingleChildLayout(
          delegate: PopupMenuRouteLayout(
            position,
            null,
            Directionality.of(widget.btnContext),
            widget.width,
            widget.menuWidth,
            widget.height,
          ),
          child: contentBuild(),
        );
      }),
    );
  }

  Widget body(double width) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Visibility(
          visible: isShow,
          child: CustomPaint(
            size: Size(width, _triangleHeight),
            painter: TrianglePainter(
              color: itemBgColor,
              position: position,
              isInverted: true,
              size: button.size,
              screenWidth: MediaQuery.of(context).size.width,
            ),
          ),
        ),
        Visibility(
          visible: isShow,
          child: Expanded(
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: Container(color: itemBgColor, height: widget.menuHeight),
                ),
                Column(
                  children: widget.actions.map(itemBuild).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget contentBuild() {
    int _curPageChildCount = (_curPage + 1) * widget.pageMaxChildCount > widget.actions.length
        ? widget.actions.length % widget.pageMaxChildCount
        : widget.pageMaxChildCount;

    double _curArrowWidth = 0;
    int _curArrowCount = 0;
    double _curPageWidth = widget.menuWidth +
        (_curPageChildCount - 1 + _curArrowCount) * _separatorWidth +
        _curArrowWidth;
    return SizedBox(
      height: widget.menuHeight + _triangleHeight,
      width: _curPageWidth,
      child: Material(color: Colors.transparent, child: body(_curPageWidth)),
    );
  }

  Widget itemBuild(Map<String, String> item) {
    var row = [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: item['icon'] != null
            ? Image.asset(item['icon']!)
            : Icon(Icons.phone, color: Colors.white),
      ),
      Expanded(
        child: Container(
          height: 50,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: item['title'] == widget.actions[0]['title']
                ? null
                : Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.3),
                width: 0.2,
              ),
            ),
          ),
          child: Text(
            item['title']!,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ];
    return TextButton(
      onPressed: () {
        isShow = false;
        setState(() {});
        Navigator.of(context).pop(item['title']);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        padding: EdgeInsets.only(left: 10.0),
        child: Row(children: row),
      ),
    );
  }
}