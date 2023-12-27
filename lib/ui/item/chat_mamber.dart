import 'package:tencent_im_sdk_plugin/models/v2_tim_user_full_info.dart';
import 'package:wechat_flutter/pages/common/contacts/contacts_details_page.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/pages/common/contacts/group_launch_page.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class ChatMamBer extends StatefulWidget {
  final V2TimUserFullInfo? info;

  ChatMamBer(this.info);

  @override
  _ChatMamBerState createState() => _ChatMamBerState();
}

class _ChatMamBerState extends State<ChatMamBer> {
  @override
  Widget build(BuildContext context) {
    List<Widget> wrap = [];

    wrap.add(
      new Wrap(
        spacing: (FrameSize.winWidth() - 315) / 5,
        runSpacing: 10.0,
        children: [0].map((item) {
          return new InkWell(
            child: new Container(
              width: 55.0,
              child: new Column(
                children: <Widget>[
                  new ImageView(
                    img: strNoEmpty(widget.info?.faceUrl)
                        ? widget.info!.faceUrl
                        : defIcon,
                    width: 55.0,
                    height: 55.0,
                    fit: BoxFit.cover,
                  ),
                  new Space(height: mainSpace / 2),
                  new Text(
                    strNoEmpty(widget.info?.nickName)
                        ? widget.info!.nickName!
                        : '',
                    style: TextStyle(color: mainTextColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            onTap: () {
              if (widget.info == null) {
                return;
              }
              Get.to(new ContactsDetailsPage(
                  id: widget.info!.userID,
                  title: widget.info!.nickName,
                  avatar: widget.info!.faceUrl));
            },
          );
        }).toList(),
      ),
    );

    wrap.add(
      new InkWell(
        child: new Container(
          decoration:
              BoxDecoration(border: Border.all(color: lineColor, width: 0.2)),
          child: new Image.asset('assets/images/chat/ic_details_add.png',
              width: 55.0, height: 55.0, fit: BoxFit.cover),
        ),
        onTap: () => Get.to(new GroupLaunchPage()),
      ),
    );

    return Container(
      color: Colors.white,
      width: FrameSize.winWidth(),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: new Wrap(
        spacing: (FrameSize.winWidth() - 315) / 5,
        runSpacing: 10.0,
        children: wrap,
      ),
    );
  }
}
