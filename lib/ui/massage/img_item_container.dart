import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/w_pop/magic_pop.dart';

class ImgItemContainer extends StatefulWidget {
  final Widget child;
  final double? height;

  ImgItemContainer({required this.child, this.height});

  @override
  _ImgItemContainerState createState() => _ImgItemContainerState();
}

class _ImgItemContainerState extends State<ImgItemContainer> {
  @override
  Widget build(BuildContext context) {
    return MagicPop(
      onValueChanged: (int value) {
        switch (value) {
          case 0:
            print('复制消息到剪贴板');
            break;
          case 3:
            print('删除消息');
            break;
        }
      },
      pressType: PressType.longPress,
      actions: ['转发', '收藏', '撤回', '删除'],
      child: Container(
        height: widget.height,
        constraints: BoxConstraints(
          maxWidth: (Get.width - 66) - 100,
          maxHeight: 250,
        ),
        padding: EdgeInsets.all(5.0),
        width: (Get.width - 66) - 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: widget.child,
      ),
    );
  }
}