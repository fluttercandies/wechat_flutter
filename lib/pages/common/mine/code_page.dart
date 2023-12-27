import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tencent_im_sdk_plugin/models/v2_tim_group_info.dart';
import 'package:wechat_flutter/tools/provider/global_model.dart';
import 'package:wechat_flutter/tools/config/app_config.dart';
import 'package:wechat_flutter/tools/data/qr_data.dart';
import 'package:wechat_flutter/ui/dialog/code_dialog.dart';
import 'package:flutter/material.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class CodePage extends StatefulWidget {
  final bool isGroup;
  final String id;
  final V2TimGroupInfo? dataGroupInfo;

  CodePage({
    this.isGroup = false,
    required this.id,
    this.dataGroupInfo,
  });

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  List data = ['换个样式', '保存到手机', '扫描二维码', '重置二维码'];
  List groupData = ['保存到手机', '扫描二维码'];

  GlobalKey rootWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = rootWidgetKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await (image.toByteData(format: ui.ImageByteFormat.png));
      if (byteData != null) {
        final result = await ImageGallerySaver.saveImage(
          byteData.buffer.asUint8List(),
          isReturnImagePathOfIOS: false,
          quality: 100,
        );
        print("ImageGallerySaver.saveImage::" + json.encode(result));
        if (result['isSuccess']) {
          q1Toast(
              Platform.isAndroid ? '保存图片成功,路径${result['filePath']}' : "保存图片成功");
        } else {
          q1Toast( '保存图片失败');
        }
      }
    } catch (e) {
      print("_capturePng::error::" + e.toString());
      q1Toast( '保存图片失败');
    }
    return null;
  }

  Future action(String item) async {
    switch (item) {
      case "保存到手机":
        _capturePng();
        break;
      default:
        q1Toast( "敬请期待");
        break;
    }
  }

  Future _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print("Permission.storage::$info");
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GlobalModel>(context);

    DateTime dt = DateTime.now().add(Duration(days: 7));
    final String dtStr = "${dt.month}月${dt.day}";

    var rWidget = [
      new SizedBox(
        width: 60,
        child: new TextButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.all(0)),
          ),
          onPressed: () async {
            final value = await codeDialog(
              context,
              widget.isGroup ? groupData : data,
            );
            if (value == null) {
              return;
            }
            action(value);
          },
          child: new Image.asset(contactAssets + 'ic_contacts_details.png'),
        ),
      )
    ];

    return new Scaffold(
      backgroundColor: chatBg,
      appBar: new ComMomBar(
          title: '${widget.isGroup ? '群' : ''}二维码名片', rightDMActions: rWidget),
      body: new SingleChildScrollView(
        child: RepaintBoundary(
          key: rootWidgetKey,
          child: new Container(
            margin: EdgeInsets.only(
                left: 20.0, right: 20.0, top: FrameSize.winHeight() / 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: new Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: new Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    width: FrameSize.winWidth() - 40.0,
                    child: new CardPerson(
                      name: model.nickName,
                      area: '北京 海淀',
                      icon: 'assets/images/Contact_Male.webp',
                      avatar: widget.isGroup ? defGroupAvatar : model.avatar,
                      groupName: widget.isGroup
                          ? widget.dataGroupInfo!.groupName ?? widget.id
                          : null,
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    alignment: Alignment.center,
                    child: QrImage(
                      data: QrData.generateData(widget.isGroup, widget.id),
                      version: QrVersions.auto,
                      size: FrameSize.winWidth() - 110,
                    ),
                  ),
                  new Text(
                    '${widget.isGroup ? '该二维码7天内($dtStr前)有效，重新进入将更新' : '扫一扫上面的二维码图案，加我${AppConfig.appName}'}',
                    style: TextStyle(color: mainTextColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardPerson extends StatelessWidget {
  final String? name, icon, area, groupName, avatar;

  CardPerson({this.name, this.icon, this.area, this.groupName, this.avatar});

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(right: 15.0),
          child: new ImageView(
            img: avatar,
            width: 45,
            height: 45,
            fit: BoxFit.cover,
          ),
        ),
        strNoEmpty(groupName)
            ? new Text(
                groupName ?? '',
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600),
              )
            : new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Text(
                        name ?? '',
                        style: TextStyle(
                            fontSize: 17.0, fontWeight: FontWeight.w600),
                      ),
                      new Space(width: mainSpace / 2),
                      new Image.asset(
                        icon ?? '',
                        width: 18.0,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  new Space(height: mainSpace / 3),
                  new Text(
                    area ?? '',
                    style: TextStyle(fontSize: 14.0, color: mainTextColor),
                  ),
                ],
              )
      ],
    );
  }
}
