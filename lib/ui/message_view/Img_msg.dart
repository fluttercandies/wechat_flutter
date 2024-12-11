import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_image.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_image_elem.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';

import '../../provider/global_model.dart';
import '../../tools/wechat_flutter.dart';
import 'msg_avatar.dart';

class ImgMsg extends StatelessWidget {
  const ImgMsg(this.model, {super.key});

  final V2TimMessage model;

  @override
  Widget build(BuildContext context) {
    final V2TimImageElem imageElem = model.imageElem!;
    if (!listNoEmpty(imageElem.imageList)) {
      return const Text('发送中');
    }
    final V2TimImage? msgInfo = imageElem.imageList![1];
    final double height = msgInfo!.height!.toDouble();
    final double resultH = height > 200.0 ? 200.0 : height;
    final String url = msgInfo.url!;
    final bool isFile = File(url).existsSync();
    final GlobalModel globalModel = Provider.of<GlobalModel>(context);
    List<Widget> body = <Widget>[
      MsgAvatar(model: model, globalModel: globalModel),
      const SizedBox(width: mainSpace),
      Expanded(
        child: GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: isFile
                  ? Image.file(File(url))
                  : CachedNetworkImage(
                      imageUrl: url, height: resultH, fit: BoxFit.cover),
            ),
          ),
          onTap: () => Get.to<void>(
            PhotoView(
              imageProvider: isFile ? FileImage(File(url)) : NetworkImage(url),
              onTapUp: (BuildContext c, TapUpDetails f,
                      PhotoViewControllerValue s) =>
                  Navigator.of(context).pop(),
              maxScale: 3.0,
              minScale: 1.0,
            ),
          ),
        ),
      ),
      const Spacer(),
    ];
    if (model.userID == globalModel.account) {
      body = body.reversed.toList();
    } else {
      body = body;
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(children: body),
    );
  }
}
