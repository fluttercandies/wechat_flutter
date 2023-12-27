import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/commom/check.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class ImageView extends StatelessWidget {
  final String? img;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool isRadius;

  ImageView({
    required this.img,
    this.height,
    this.width,
    this.fit,
    this.isRadius = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget image;

    Widget defWidget = new Container(
      decoration: BoxDecoration(
          color: Colors.black26.withOpacity(0.1),
          border: Border.all(color: Colors.black.withOpacity(0.2), width: 0.3)),
      child: new Image.asset(
        defIcon,
        width: (width ?? 1) - 1,
        height: (height ?? 1) - 1,
        fit: width != null && height != null ? BoxFit.fill : fit,
      ),
    );
    try {
      if (!strNoEmpty(img)) {
        image = new Image.asset(
          defIcon,
          width: width,
          height: height,
          fit: width != null && height != null ? BoxFit.fill : fit,
        );
      } else if (isNetWorkImg(img)) {
        LogUtil.d("img avatar::$img");
        image = new CachedNetworkImage(
          imageUrl: img!,
          width: width,
          height: height,
          fit: fit,
          cacheManager: cacheManager,
          errorWidget: (
            BuildContext context,
            String url,
            dynamic error,
          ) {
            return defWidget;
          },
          placeholder: (BuildContext context, String url) {
            return defWidget;
          },
        );
      } else if (File(img!).existsSync()) {
        image = new Image.file(
          File(img!),
          width: width,
          height: height,
          fit: fit,
        );
      } else if (isAssetsImg(img)) {
        image = new Image.asset(
          img!,
          width: width,
          height: height,
          fit: width != null && height != null ? BoxFit.fill : fit,
        );
      } else {
        image = defWidget;
      }
    } catch (e) {
      print("加载头像出现错误::${e.toString()}");
      image = defWidget;
    }

    if (isRadius) {
      return new ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(4.0),
        ),
        child: image,
      );
    }
    return image;
  }
}
