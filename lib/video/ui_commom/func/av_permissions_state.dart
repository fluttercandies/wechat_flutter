import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AvPermissionsBuilder extends StatefulWidget {
  final Widget child;

  const AvPermissionsBuilder({required this.child, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AvPermissionsBuilderState();
  }
}

class _AvPermissionsBuilderState extends State<AvPermissionsBuilder> {
  bool isHasPermission = false;

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  /*
  * 检测权限
  * */
  Future checkPermission() async {
    List<Permission> permissions = [
      Permission.camera,
      Permission.microphone,
    ];
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    if (statuses[Permission.camera] != PermissionStatus.granted ||
        statuses[Permission.microphone] != PermissionStatus.granted) {
      Get.back();
      Get.defaultDialog(
        title: '提示',
        content: const Text('请到系统内设置允许本应用使用麦克风和摄像头权限~'),
        textConfirm: "确定",
        onConfirm: () {
          Get.back();
          openAppSettings();
        },
      );
    } else {
      isHasPermission = true;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isHasPermission) {
      return Container(color: Colors.black);
    }
    return widget.child;
  }
}
