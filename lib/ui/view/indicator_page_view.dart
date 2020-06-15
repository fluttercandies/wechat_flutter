import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class IndicatorPageView extends StatefulWidget {
  final PageController pageC;
  final List<Widget> pages;

  IndicatorPageView({this.pageC, this.pages});

  IndicatorPageViewState createState() => IndicatorPageViewState();
}

class IndicatorPageViewState extends State<IndicatorPageView> {
  int currentMoreIndex = 0;
  double size = 5.0;

  Widget itemView(index) {
    return new Container(
      height: size,
      width: size,
      margin: EdgeInsets.symmetric(horizontal: size),
      decoration: BoxDecoration(
        color: currentMoreIndex == index
            ? Colors.black
            : Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.all(
          Radius.circular(size / 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          new ScrollConfiguration(
            behavior: MyBehavior(),
            child: new PageView(
              controller: widget.pageC,
              onPageChanged: (v) {
                setState(() => currentMoreIndex = v);
              },
              children: widget.pages,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.pages.length, itemView),
            ),
          )
        ],
      ),
      onTap: () {},
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    } else {
      return super.buildViewportChrome(context, child, axisDirection);
    }
  }
}
