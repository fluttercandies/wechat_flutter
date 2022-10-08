import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_scankit/scan_kit_widget.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

const boxSize = 200.0;

class _ScanPageState extends State<ScanPage> {
  ScanKitController _controller;

  final screenWidth = window.physicalSize.width;
  final screenHeight = window.physicalSize.height;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var pixelSize = boxSize * window.devicePixelRatio;
    var left = screenWidth / 2 - pixelSize / 2;
    var top = screenHeight / 2 - pixelSize / 2;
    var right = screenWidth / 2 + pixelSize / 2;
    var bottom = screenHeight / 2 + pixelSize / 2;
    var rect = Rect.fromLTRB(left, top, right, bottom);

    return Scaffold(
      body: Stack(
        children: [
          ScanKitWidget(
              callback: (controller) {
                _controller = controller;

                controller.onResult.listen((result) {
                  debugPrint("scanning result:$result");

                  Navigator.of(context).pop(result);
                });
              },
              continuouslyScan: false,
              boundingBox: rect),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      )),
                  IconButton(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      onPressed: () {
                        _controller.switchLight();
                      },
                      icon: Icon(
                        Icons.lightbulb_outline_rounded,
                        color: Colors.white,
                        size: 28,
                      )),
                  IconButton(
                    onPressed: () {
                      _controller.pickPhoto();
                    },
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    icon: Icon(
                      Icons.picture_in_picture_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: boxSize,
              height: boxSize,
              decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(color: Colors.orangeAccent, width: 2),
                    right: BorderSide(color: Colors.orangeAccent, width: 2),
                    top: BorderSide(color: Colors.orangeAccent, width: 2),
                    bottom: BorderSide(color: Colors.orangeAccent, width: 2)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
