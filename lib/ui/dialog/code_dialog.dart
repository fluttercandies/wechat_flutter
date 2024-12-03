import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

void codeDialog(BuildContext context, List<String> items) {
  Widget item(String item) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        border: item != '重置二维码'
            ? Border(
                bottom: BorderSide(color: lineColor, width: 0.2),
              )
            : null,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15.0),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          showToast( '$item正在开发中');
        },
        child: Text(item),
      ),
    );
  }

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  child: Container(),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Column(children: items.map(item).toList()),
                      HorizontalLine(color: appBarColor, height: 10.0),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Container(
                          width: Get.width,
                          alignment: Alignment.center,
                          child: Text('取消'),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
