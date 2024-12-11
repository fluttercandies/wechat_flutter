import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_image.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_image_elem.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:wechat_flutter/im/model/chat_data.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui/message_view/msg_avatar.dart';

import '../../provider/global_model.dart';

class ImgMsg extends StatelessWidget {
  final V2TimMessage model;

  ImgMsg(this.model);

  @override
  Widget build(BuildContext context) {
    final V2TimImageElem imageElem = model.imageElem!;
    if (!listNoEmpty(imageElem.imageList)) {
      return const Text('发送中');
    }
    final V2TimImage? msgInfo = imageElem.imageList[1];
    final double _height = msgInfo!.height!.toDouble();
    final double resultH = _height > 200.0 ? 200.0 : _height;
    final String url = msgInfo.url!;
    final isFile = File(url).existsSync();
    final globalModel = Provider.of<GlobalModel>(context);
    var body = [
      new MsgAvatar(model: model, globalModel: globalModel),
      new SizedBox(width: mainSpace),
      new Expanded(
        child: new GestureDetector(
          child: new Container(
            padding: const EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: new ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: isFile
                  ? new Image.file(File(url))
                  : new CachedNetworkImage(
                      imageUrl: url, height: resultH, fit: BoxFit.cover),
            ),
          ),
          onTap: () => Get.to<void>(
            new PhotoView(
              imageProvider: isFile ? FileImage(File(url)) : NetworkImage(url),
              onTapUp: (c, f, s) => Navigator.of(context).pop(),
              maxScale: 3.0,
              minScale: 1.0,
            ),
          ),
        ),
      ),
      new Spacer(),
    ];
    if (model.userID == globalModel.account) {
      body = body.reversed.toList();
    } else {
      body = body;
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: new Row(children: body),
    );
  }
}
