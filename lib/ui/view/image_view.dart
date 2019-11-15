import 'package:flutter/material.dart';

import 'package:dim_example/tools/wechat_flutter.dart';

class ImageView extends StatelessWidget {
  final String img;

  final double width;
  final double height;
  final BoxFit fit;
  final bool isRadius;

  ImageView({
    @required this.img,
    this.height,
    this.width,
    this.fit,
    this.isRadius = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (isNetWorkImg(img)) {
      image = new CachedNetworkImage(
        imageUrl: img,
        width: width,
        height: height,
        fit: fit,
        cacheManager: cacheManager,
      );
    } else if (File(img).existsSync()) {
      image = new Image.file(
        File(img),
        width: width,
        height: height,
        fit: fit,
      );
    } else if (isAssetsImg(img)) {
      image = new Image.asset(
        img,
        width: width,
        height: height,
        fit: width != null && height != null ? BoxFit.fill : fit,
      );
    } else {
      image = new Container(
        color: Colors.black26.withOpacity(0.1),
        child: new CachedNetworkImage(
          imageUrl: gitDefAvatar,
          width: width,
          height: height,
          fit: width != null && height != null ? BoxFit.fill : fit,
        ),
      );
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
