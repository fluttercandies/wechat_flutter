import 'package:flutter/material.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';
import 'package:wechat_flutter/ui_commom/image/sw_image.dart';

typedef ClickEventCallback = Future<void> Function();

class AvatarView extends SwAvatar{
  AvatarView(String? image) : super(image);
}

class SwAvatar extends StatelessWidget {
  final String? image;
  final double size;
  final ClickEventCallback? onTap;
  final bool isBorder;

  /// When no avatar use male def img.
  final bool isMaleDef;

  const SwAvatar(
    this.image, {
    this.size = 30,
    this.onTap,
    this.isBorder = false,
    this.isMaleDef = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget result;
    Widget defAvatar = SwImage(
      isMaleDef ? "assets/images/pic_register_def_n.png" : AppConfig.defPic,
      width: size,
      height: size,
      onTap: onTap,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.all(Radius.circular(size / 2)),
    );
    if (!strNoEmpty(image)) {
      result = defAvatar;
      return result;
    }
    result = SwImage(
      image,
      width: size,
      height: size,
      onTap: onTap,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.all(Radius.circular(size / 2)),
      placeholder: (context, url) {
        return defAvatar;
      },
      errorWidget: (context, url, e) {
        return defAvatar;
      },
    );
    if (isBorder) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(size / 2)),
          border: Border.all(color: Colors.white),
        ),
        child: result,
      );
    }
    return result;
  }
}
