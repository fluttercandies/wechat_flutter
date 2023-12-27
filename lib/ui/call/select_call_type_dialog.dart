import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

Future<int?> selectCallTypeDialog(BuildContext context) async {
  final List _pickerSheetList = ["视频通话", '语音通话', '取消'];

  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return SelectCallTypeDialog(titleList: _pickerSheetList);
      });
}

/// 底部弹出框
class SelectCallTypeDialog extends StatefulWidget {
  final List? titleList;

  const SelectCallTypeDialog({Key? key, this.titleList}) : super(key: key);

  @override
  SelectCallTypeDialogState createState() => SelectCallTypeDialogState();
}

typedef OnItemClickListener = void Function(int index);

class SelectCallTypeDialogState extends State<SelectCallTypeDialog> {
  double? itemHeight = FrameSize.px(44);
  double? speedH = FrameSize.px(10);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: itemHeight! * 3 + speedH! + 2,
        child: Column(children: [
          _sheetItem(0, FrameSize.px(10)),
          Container(height: FrameSize.px(1), color: const Color(0xFFF3F3F3)),
          _sheetItem(1, 0),
          Container(height: FrameSize.px(10), color: const Color(0xFFF3F3F3)),
          _sheetItem(2, 0),
        ]),
      ),
    );
  }

  Widget _sheetItem(int index, double radius) {
    return Container(
      height: itemHeight,
      width: FrameSize.screenW(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius)),
        color: Colors.white,
      ),
      child: MaterialButton(
        onPressed: () {
          if (index != 2) {
            Get.back(result: index);
          }
        },
        child: Text(
          widget.titleList![index],
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
