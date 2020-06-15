import 'package:wechat_flutter/pages/wechat_friends/from.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart' as prefix1;
import 'package:wechat_flutter/ui/w_pop/friend_pop.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:flutter/material.dart' as prefix0;

import 'load_view.dart';

class ItemDynamic extends StatelessWidget {
  final FriendsDynamic dynamic;

  ItemDynamic(this.dynamic, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int imageSize = this.dynamic.images.length;

    double imageWidth = (winWidth(context) - 20 - 50 - 10) /
        ((imageSize == 3 || imageSize > 4)
            ? 3.0
            : (imageSize == 2 || imageSize == 4) ? 2.0 : 1.5);

    double videoWidth = (winWidth(context) - 20 - 50 - 10) / 2.2;

    String desc = this.dynamic.desc;

    String def =
        'https://c-ssl.duitang.com/uploads/item/201803/04/20180304085215_WGFx8.thumb.700_0.jpeg';

    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ImageLoadView(
              '${this.dynamic?.userAvatar ?? def}',
              height: 50,
              width: 50,
              borderRadius: BorderRadius.circular(5.0),
            ),
            Expanded(
              child: Container(
                  padding: EdgeInsets.only(left: 10.0, top: 8),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /// 发布者昵称
                        Text('${this.dynamic.username}'),

                        /// 发布的文字描述
                        Offstage(
                            offstage: desc.isEmpty,
                            child: Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text('$desc',
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis))),

                        /// 图片区域
                        Offstage(
                            offstage: imageSize == 0,
                            child: imageSize > 1
                                ? GridView.builder(
                                    padding: EdgeInsets.only(top: 8.0),
                                    itemCount: imageSize,
                                    shrinkWrap: true,
                                    primary: false,
                                    gridDelegate:
                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: imageWidth,
                                            crossAxisSpacing: 2.0,
                                            mainAxisSpacing: 2.0,
                                            childAspectRatio: 1),
                                    itemBuilder: (context, index) =>
                                        ImageLoadView(
                                          '${this.dynamic.images.isNotEmpty ? this.dynamic.images[index].image : def}',
                                          fit: BoxFit.cover,
                                          width: imageWidth,
                                          height: imageWidth,
                                        ))
                                : imageSize == 1
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 8.0),
                                        child: ImageLoadView(
                                          this.dynamic?.images?.first?.image ??
                                              def,
                                          width: imageWidth,
                                          height: imageWidth,
                                          fit: BoxFit.cover,
                                        ))
                                    : SizedBox()),

                        /// 视频区域
                        Offstage(
                            offstage: this.dynamic.video == null,
                            child: Container(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    ImageLoadView(
                                      '${this.dynamic.video?.image ?? def}',
                                      height: 200,
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.play_arrow,
                                            color: Colors.white),
                                        onPressed: () {})
                                  ],
                                ),
                                width: videoWidth)),

                        /// 定位地址
                        Offstage(
                            offstage: imageSize % 2 == 0,
                            child: Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text('${this.dynamic.address}',
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 13)))),

                        /// 发布时间
                        Row(children: <Widget>[
                          Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text('${this.dynamic.datetime}',
                                    style: TextStyle(
                                        color: Colors.grey[500], fontSize: 13)),
                                Offstage(
                                    offstage: !this.dynamic.isSelf,
                                    child: Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Text('删除',
                                            style: TextStyle(
                                                color: Colors.blueAccent))))
                              ]),
                          TestPush(),
                        ], mainAxisAlignment: MainAxisAlignment.spaceBetween),

                        /// 评论部分
                      ])),
            )
          ],
        ),
        Container(
            height: 0.5,
            color: Colors.grey[200],
            margin: EdgeInsets.only(top: 10))
      ]),
    );
  }


}

class TestPush extends StatefulWidget {
  @override
  _TestPushState createState() => _TestPushState();
}

class _TestPushState extends State<TestPush> {

  Widget _buildExit() {
    TextStyle labelStyle = TextStyle(color: Colors.white);
    return Container(
      width: 200,
      height: 36,
      decoration: BoxDecoration(
        color: itemBgColor,
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
      ),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new FlatButton(
              onPressed: () {},
              child: new Text('赞', style: labelStyle),
            ),
          ),
          new Expanded(
            child: new FlatButton(
              onPressed: () {},
              child: new Text('评论', style: labelStyle),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.more_horiz, color: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            PopRoute(
              child: Popup(
                btnContext: context,
                child: _buildExit(),
                onClick: () {
                  print("exit");
                },
              ),
            ),
          );
        });
  }
}
