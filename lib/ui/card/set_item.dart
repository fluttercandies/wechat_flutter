import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/commom/check.dart';

class SetItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final bool isBorder;
  final String text;
  final String bottomText;
  final String subText;
  final Widget rWidget;

  SetItem({
    this.onTap,
    this.isBorder,
    this.text,
    this.bottomText,
    this.subText,
    this.rWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: rWidget == null ? 15 : 10),
          margin: EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withOpacity(isBorder ? 0 : 0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  if (strNoEmpty(bottomText))
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        bottomText,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
              Spacer(),
              if (strNoEmpty(subText))
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Text(
                    subText,
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
              if (rWidget != null)
                rWidget
              else
                Container(
                  margin: EdgeInsets.only(right: 15),
                  child: Icon(
                    CupertinoIcons.right_chevron,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
