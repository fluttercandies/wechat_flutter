import 'dart:io';

import 'package:wechat_flutter/tools/utils/file_util.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';

class UpdateDialog extends StatefulWidget {
  final String version;
  final String updateInfo;
  final String updateUrl;
  final bool isForce;

  UpdateDialog({
    this.version = "1.0.0",
    this.updateInfo = "",
    this.updateUrl = "",
    this.isForce = false,
  });

  @override
  State<StatefulWidget> createState() => new UpdateDialogState();
}

class UpdateDialogState extends State<UpdateDialog> {
  int _downloadProgress = 0;
  CancelToken token;
  UploadingFlag uploadingFlag = UploadingFlag.idle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isVertical = size.height > size.width;
    final marginLeft = isVertical ? 25.0 : size.width / 4;
    final marginTop = isVertical ? size.height / 2.6 : size.height / 8;

    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        margin:
            EdgeInsets.fromLTRB(marginLeft, marginTop, marginLeft, marginTop),
        decoration:
            BoxDecoration(shape: BoxShape.rectangle, color: Colors.white),
        padding: EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                alignment: Alignment.centerLeft,
                child: Material(
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text(
                      widget.updateInfo ?? "",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ),
                ),
              ),
            ),
            getLoadingWidget(),
            Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  new Space(width: (winWidth(context) - 40) / 2),
                  !widget.isForce
                      ? Expanded(
                          flex: 1,
                          child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                '取消',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              )),
                        )
                      : SizedBox(),
                  Expanded(
                    flex: 1,
                    child: FlatButton(
                        onPressed: () async {
                          if (uploadingFlag == UploadingFlag.uploading) return;
                          uploadingFlag = UploadingFlag.uploading;
                          if (mounted) setState(() {});
                          if (Platform.isAndroid) {
                            _androidUpdate();
                          } else if (Platform.isIOS) {
                            _iosUpdate();
                          }
                        },
                        child: Text(
                          '更新',
                          style: TextStyle(color: Colors.green, fontSize: 16),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _androidUpdate() async {
    final apkPath = await FileUtil.getInstance().getSavePath("/Download/");
    try {
      await Req.getInstance().client.download(
        widget.updateUrl,
        apkPath + "wechat_flutter.apk",
        cancelToken: token,
        onReceiveProgress: (int count, int total) {
          if (mounted) {
            setState(() {
              _downloadProgress = ((count / total) * 100).toInt();
              if (_downloadProgress == 100) {
                if (mounted) {
                  setState(() {
                    uploadingFlag = UploadingFlag.uploaded;
                  });
                }
                debugPrint("读取的目录:$apkPath");
                try {
                  OpenFile.open(apkPath + "wechat_flutter.apk");
                } catch (e) {}
                Navigator.of(context).pop();
              }
            });
          }
        },
        options: Options(sendTimeout: 15 * 1000, receiveTimeout: 360 * 1000),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          uploadingFlag = UploadingFlag.uploadingFailed;
        });
      }
    }
  }

  Widget getLoadingWidget() {
    if (_downloadProgress != 0 && uploadingFlag == UploadingFlag.uploading) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            backgroundColor: Colors.grey[300],
            value: _downloadProgress / 100,
          ),
        ),
        flex: 1,
      );
    }
    if (uploadingFlag == UploadingFlag.uploading && _downloadProgress == 0) {
      return Container(
        alignment: Alignment.center,
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(mainTextColor),
            ),
            SizedBox(
              width: 5,
            ),
            Material(
              child: Text(
                '等待',
                style: TextStyle(color: mainTextColor),
              ),
              color: Colors.transparent,
            )
          ],
        ),
      );
    }
    if (uploadingFlag == UploadingFlag.uploadingFailed) {
      return Container(
          alignment: Alignment.center,
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.clear,
                color: Colors.redAccent,
              ),
              SizedBox(
                width: 5,
              ),
              Material(
                child: Text(
                  '下载超时',
                  style: TextStyle(color: mainTextColor),
                ),
                color: Colors.transparent,
              )
            ],
          ));
    }
    return Container();
  }

  void _iosUpdate() {
    launch(widget.updateUrl);
  }

  @override
  void initState() {
    super.initState();
    token = new CancelToken();
  }

  @override
  void dispose() {
    if (!token.isCancelled) token?.cancel();
    super.dispose();
    debugPrint("升级销毁");
  }
}

enum UploadingFlag { uploading, idle, uploaded, uploadingFailed }
