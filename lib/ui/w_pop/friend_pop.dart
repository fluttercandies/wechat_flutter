import 'package:flutter/material.dart';

class PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  PopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}

class Popup extends StatefulWidget {
  final BuildContext btnContext;
  final Widget child;
  final Function onClick; //点击child事件

  Popup({
    this.btnContext,
    @required this.child,
    this.onClick,
  });

  PopupState createState() => PopupState();
}

class PopupState extends State<Popup> {
  RenderBox button;
  RenderBox overlay;
  RelativeRect position;

  @override
  void initState() {
    super.initState();
    button = widget.btnContext.findRenderObject();
    overlay = Overlay.of(widget.btnContext).context.findRenderObject();
    position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(Offset.zero, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
  }

  TextStyle style = TextStyle(color: Colors.red);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
              child: new Column(
                children: <Widget>[
                  new Container(
                    color: Colors.cyan.withOpacity(0.5),
                    margin: EdgeInsets.only(top: 80),
                    padding: EdgeInsets.all(20.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Text('position.bottom:: ${position.bottom}', style: style),
                        new Text('position.top:: ${position.top}', style: style),
                        new Text('position.left:: ${position.left}', style: style),
                        new Text('position.right:: ${position.right}', style: style),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              child: GestureDetector(
                child: widget.child,
                onTap: () {
                  //点击子child
                  if (widget.onClick != null) {
                    Navigator.of(context).pop();
                    widget.onClick();
                  }
                },
              ),
              top: position.top,
              right: position.right,
            ),
          ],
        ),
        onTap: () {
          //点击空白处
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
