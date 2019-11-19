import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum ImageType { network, assets, localFile }

class ImageLoadView extends StatelessWidget {
  /// 图片URL
  final String path;

  /// 宽
  final double width;

  /// 高
  final double height;

  /// 填充效果
  final BoxFit fit;

  /// 圆角
  final BorderRadius borderRadius;

  ImageLoadView(
    this.path, {
    Key key,
    this.width,
    this.height,
    this.fit: BoxFit.fill,
    this.borderRadius: const BorderRadius.all(Radius.circular(0.0)),
  }) : assert(path != null);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
          imageUrl: path, height: height, width: width, fit: fit),
    );
  }
}
