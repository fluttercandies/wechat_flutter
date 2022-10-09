import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class ScrollDialog extends StatefulWidget {
  final Widget child;
  final bool barrierDismissible;
  final WillPopCallback onWillPop;
  final bool isDecoration;
  final double width;
  final double height;

  const ScrollDialog({
    @required this.child,
    this.barrierDismissible = false,
    this.isDecoration = false,
    this.onWillPop,
    this.height,
    this.width,
  });

  @override
  _ScrollDialogState createState() => _ScrollDialogState();
}

class _ScrollDialogState extends State<ScrollDialog> {
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 600)).then((value) {
      if (mounted) setState(() {});
    });
  }

  double getHeight() {
    final RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
    double size;
    final _fullHeight = winHeight(context) - winTop(context);
    final _boxHeight = box?.size?.height ?? 0;
    if (_boxHeight == 0) {
      size = _fullHeight;
    } else {
      size = _boxHeight > _fullHeight ? _boxHeight : _fullHeight;
    }
    return size;
  }

  @override
  Widget build(BuildContext context) {
    final _content = Material(
      type: MaterialType.transparency,
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: getHeight(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.isDecoration)
                  Container(
                    key: key,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 24),
                    width: winWidth(context) - 60,
                    child: widget.child,
                  )
                else
                  Container(
                    key: key,
                    child: widget.child,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    if (widget.onWillPop != null) {
      return WillPopScope(
        onWillPop: widget.onWillPop,
        child: _content,
      );
    } else if (widget.barrierDismissible) {
      return GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: _content,
      );
    } else {
      return _content;
    }
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    if (kIsWeb) {
      return super.buildOverscrollIndicator(context, child, details);
    } else if (Platform.isAndroid || Platform.isFuchsia) {
      return child;
    } else {
      return super.buildOverscrollIndicator(context, child, details);
    }
  }
}
