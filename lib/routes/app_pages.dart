import 'package:get/get.dart';
import 'package:wechat_flutter/app.dart';
import 'package:wechat_flutter/pages/common/chat/chat_page/chat_binding.dart';
import 'package:wechat_flutter/pages/common/chat/chat_page/chat_view.dart';
import 'package:wechat_flutter/pages/common/more/add_friend/add_friend_binding.dart';
import 'package:wechat_flutter/pages/common/more/add_friend/add_friend_view.dart';
import 'package:wechat_flutter/pages/root/root/root_binding.dart';
import 'package:wechat_flutter/pages/root/root/root_view.dart';
import 'package:wechat_flutter/video/pages/audio_single/binding.dart';
import 'package:wechat_flutter/video/pages/audio_single/view.dart';
import 'package:wechat_flutter/video/pages/video_sigle/binding.dart';
import 'package:wechat_flutter/video/pages/video_sigle/view.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = <GetPage>[
    GetPage(
      name: RouteConfig.startPage,
      page: () => StartPage(),
      // binding: RootBinding(),
    ),
    GetPage(
      name: RouteConfig.rootPage,
      page: () => RootPage(),
      binding: RootBinding(),
    ),
    GetPage(
      name: RouteConfig.addFriendPage,
      page: () => AddFriendPage(),
      binding: AddFriendBinding(),
    ),
    GetPage(
      name: RouteConfig.videoSinglePage,
      page: () => VideoSinglePage(),
      binding: VideoSingleBinding(),
    ),
    GetPage(
      name: RouteConfig.audioSinglePage,
      page: () => AudioSinglePage(),
      binding: AudioSingleBinding(),
    ),
    GetPage(
      name: RouteConfig.chatPage,
      page: () => ChatPage(),
      binding: ChatBinding(),
    ),
  ];
}
