import 'package:flutter/material.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
import 'package:wechat_flutter/tools/commom/check.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class SearchRecordResultPage extends StatefulWidget {
  List<V2TimMessage> messageSearchResultItems;

  SearchRecordResultPage(this.messageSearchResultItems);

  @override
  State<SearchRecordResultPage> createState() => _SearchRecordResultPageState();
}

class _SearchRecordResultPageState extends State<SearchRecordResultPage> {
  @override
  Widget build(BuildContext context) {
    List<V2TimMessage> msgList = widget.messageSearchResultItems;
    return ListView.builder(
      itemCount: msgList.length,
      itemBuilder: (context, index) {
        V2TimMessage model = msgList[index];
        return ListTile(
          title: Text(
              strNoEmpty(model.nameCard) ? model.nameCard! : model.nickName!),
          leading: ImageView(img: model.faceUrl),
          subtitle: Text(model.textElem != null ? model.textElem!.text! : ""),
        );
      },
    );
  }
}
