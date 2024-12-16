import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_sdk/manager/v2_tim_manager.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message_online_url.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_value_callback.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_video_elem.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

import '../../provider/global_model.dart';

class VideoMessage extends StatefulWidget {
  final V2TimMessage msg;

  VideoMessage(this.msg);

  @override
  _VideoMessageState createState() => _VideoMessageState();
}

class _VideoMessageState extends State<VideoMessage> {
  Rxn<V2TimVideoElem> videoElement = Rxn<V2TimVideoElem>();

  @override
  void initState() {
    super.initState();
    getSnapshot();
  }

  Future<void> getSnapshot() async {
    videoElement.value = widget.msg.videoElem;
    final V2TimValueCallback<V2TimMessageOnlineUrl> callback =
        await V2TIMManager()
            .getMessageManager()
            .getMessageOnlineUrl(msgID: widget.msg.msgID!);
    if (callback.data?.videoElem != null) {
      videoElement.value = callback.data!.videoElem;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalModel globalModel = Provider.of<GlobalModel>(context);
    final bool isSelf = widget.msg.sender == globalModel.account;
    if (videoElement.value == null) {
      return Container();
    }
    return Obx(() {
      Widget time() {
        return Container(
          margin: const EdgeInsets.only(right: 8.0, bottom: 5.0),
          alignment: Alignment.bottomRight,
          child: Text(
            '0:0${videoElement.value!.duration ?? 0}',
            style: const TextStyle(color: Colors.white),
          ),
        );
      }

      return SizedBox(
        height: 210,
        child: InkWell(
          onTap: () {
            showToast(
                '播放视频::${videoElement.value?.videoUrl ?? videoElement.value?.localVideoUrl ?? ''}');
          },
          child: Stack(
            children: [
              if (GetUtils.isNullOrBlank(videoElement.value?.snapshotUrl)!)
                Image.file(File(videoElement.value!.snapshotPath ?? ''))
              else
                CachedNetworkImage(imageUrl: videoElement.value!.snapshotUrl!),
              Image.asset('assets/images/ic_chat_play_icon.webp'),
              time(),
            ],
          ),
        ),
      );

      // if (isSelf) {
      //   return VerticalContainer(
      //     type: 1,
      //     children: <Widget>[
      //       MassageAvatar(widget.data, type: 1),
      //       ImgItemContainer(
      //           height: 210,
      //           child: GestureDetector(
      //             child: Stack(
      //               alignment: Alignment.center,
      //               children: <Widget>[
      //                 ClipRRect(
      //                   borderRadius:
      //                       const BorderRadius.all(Radius.circular(5.0)),
      //                   child: CachedNetworkImage(
      //                     imageUrl:
      //                         '${videoElement.snapshotUrl ? defContentImg : widget.video['snapshot']['urls'][0].toString()}',
      //                     width: double.parse(
      //                         '${widget.video['snapshot']['width']}.0'),
      //                     height: double.parse(
      //                         '${widget.video['snapshot']['height']}.0'),
      //                     fit: BoxFit.cover,
      //                     cacheManager: cacheManager,
      //                   ),
      //                 ),
      //                 Image.asset('assets/images/ic_chat_play_icon.webp'),
      //                 time(),
      //               ],
      //             ),
      //             onTap: () {
      //               Get.to<void>(
      //                 VideoPlayPage(widget.video['video']['urls'][0]),
      //               );
      //             },
      //           )),
      //     ],
      //   );
      // } else {
      //   return VerticalContainer(
      //     type: 2,
      //     children: <Widget>[
      //       ImgItemContainer(
      //           height: 210,
      //           child: GestureDetector(
      //             child: Stack(
      //               alignment: Alignment.center,
      //               children: <Widget>[
      //                 ClipRRect(
      //                   borderRadius:
      //                       const BorderRadius.all(Radius.circular(5.0)),
      //                   child: CachedNetworkImage(
      //                     imageUrl:
      //                         '${widget.video['snapshot']['urls'].toString() == '[]' ? defContentImg : widget.video['snapshot']['urls'][0].toString()}',
      //                     width: double.parse(
      //                         '${widget.video['snapshot']['width']}.0'),
      //                     height: double.parse(
      //                         '${widget.video['snapshot']['height']}.0'),
      //                     fit: BoxFit.cover,
      //                     cacheManager: cacheManager,
      //                   ),
      //                 ),
      //                 Image.asset('assets/images/ic_chat_play_icon.webp'),
      //                 time(),
      //               ],
      //             ),
      //             onTap: () {
      //               Get.to<void>(
      //                 VideoPlayPage(widget.video['video']['urls'][0]),
      //               );
      //             },
      //           )),
      //       SizedBox(width: 8.0),
      //       MassageAvatar(widget.data, type: 0),
      //     ],
      //   );
      // }
    });
  }
}
