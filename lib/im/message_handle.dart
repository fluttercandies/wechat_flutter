import 'package:dim/commom/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dim_example/tools/wechat_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

Future<dynamic> getDimMessages(String id,
    {int type, Callback callback, int num = 50}) async {
  try {
    var result = await im.getMessages(id, num, type ?? 1);
    return result;
  } on PlatformException {
    debugPrint('获取失败');
  }
}

Future<void> sendImageMsg(String userName, int type, context,
    {Callback callback}) async {
  List<Asset> resultList = List<Asset>();
  List<Asset> images = List<Asset>();
  try {
    resultList = await MultiImagePicker.pickImages(
      maxImages: 9,
      enableCamera: true,
      selectedAssets: images,
      cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
      materialOptions: MaterialOptions(
        actionBarColor: "#343434",
        actionBarTitle: "图片和视频",
        allViewTitle: "所有",
        useDetailsView: false,
        selectCircleStrokeColor: "#000000",
        selectionLimitReachedText: "已到达最大选择数量",
      ),
    );

    for (var r in resultList) {
      File image = File(await r.filePath);
      if (image == null) return;
      File compressImg = await singleCompressFile(image);

      try {
        await im.sendImageMessages(userName, compressImg.path, type: type);
        callback(compressImg.path);
      } on PlatformException {
        debugPrint("发送图片消息失败");
      }
    }
  } on Exception catch (e) {
    showToast(context, e.toString());
  }
}

Future<dynamic> sendSoundMessages(String id, String soundPath, int duration,
    int type, Callback callback) async {
  try {
    var result = await im.sendSoundMessages(id, soundPath, type, duration);
    callback(result);
  } on PlatformException {
    debugPrint('发送语音  失败');
  }
}
