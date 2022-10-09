import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_scankit/scan_kit_widget.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/pages/contacts/contacts_details_page.dart';
import 'package:wechat_flutter/pages/group/group_join_page.dart';
import 'package:wechat_flutter/tools/data/qr_data.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

const boxSize = 200.0;

class _ScanPageState extends State<ScanPage> {
  ScanKitController _controller;

  final screenWidth = window.physicalSize.width;
  final screenHeight = window.physicalSize.height;
  StreamSubscription resultListen;

  void handleResult(String result) {
    debugPrint("scanning result:$result");

    if (!QrData.isSelfCode(result)) {
      cantRec();
      return;
    }

    final List<String> qrList = QrData.fetchData(result);
    if (qrList[0] == QrDataType.group.toString()) {
      /// 如果已经加入群了直接到聊天界面
      /// 否则才到申请进群页面。
      Get.off(GroupJoinPage(groupId: qrList[1]));
    } else if (qrList[0] == QrDataType.personal.toString()) {
      Get.off(ContactsDetailsPage(id: qrList[1]));
    } else {
      cantRec();
    }
  }

  void cantRec() {
    Navigator.of(context).pop();
    showToast(context, "此内容暂时无法识别");
  }

  @override
  void initState() {
    super.initState();
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

                resultListen = _controller.onResult.listen(handleResult);
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      )),
                  IconButton(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

  @override
  void dispose() {
    _controller.dispose();
    resultListen?.cancel();
    resultListen = null;
    super.dispose();
  }
}
