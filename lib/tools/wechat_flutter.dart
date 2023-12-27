import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

export 'dart:async';
export 'dart:io';
export 'dart:ui';

export 'package:cached_network_image/cached_network_image.dart';
export 'package:flutter/services.dart';
export 'package:wechat_flutter/tools/config/api.dart';
export 'package:wechat_flutter/tools/theme/const.dart';
export 'package:wechat_flutter/tools/theme/contacts.dart';
export 'package:wechat_flutter/tools/config/strings.dart';
export 'package:wechat_flutter/tools/http/req.dart';
export 'package:wechat_flutter/tools/commom/check.dart';
export 'package:wechat_flutter/tools/commom/ui.dart';
export 'package:wechat_flutter/tools/data/data.dart';
export 'package:wechat_flutter/tools/func/shared_util.dart';
export 'package:wechat_flutter/ui/bar/commom_bar.dart';
export 'package:wechat_flutter/ui/button/commom_button.dart';
export 'package:wechat_flutter/ui/dialog/show_snack.dart';
export 'package:wechat_flutter/ui/view/image_view.dart';
export 'package:wechat_flutter/ui/view/loading_view.dart';
export 'package:wechat_flutter/ui/view/main_input.dart';
export 'package:wechat_flutter/ui/view/null_view.dart';
export 'package:wechat_flutter/ui/web/web_view.dart';
export 'package:wechat_flutter/tools/ui/fram_size.dart';
export 'package:wechat_flutter/tools/func/log.dart';
export 'package:wechat_flutter/tools/ui/q1_toast.dart';
export 'package:wechat_flutter/tools/config/keys.dart';
export 'package:wechat_flutter/tools/theme/my_theme.dart';
export 'package:wechat_flutter/tools/data/notice.dart';
export 'package:connectivity_plus/connectivity_plus.dart';
export 'package:get/get.dart'
    hide HeaderValue, Response, MultipartFile, FormData;
export 'package:wechat_flutter/tools/config/app_config.dart';
export 'package:wechat_flutter/routes/app_pages.dart';
export 'package:wechat_flutter/im/im_handle/Im_api.dart';
export 'package:wechat_flutter/tools/eventbus/msg_bus.dart';
export 'package:tencent_im_sdk_plugin/models/v2_tim_message.dart';
export 'package:tencent_im_sdk_plugin/models/v2_tim_value_callback.dart';
export 'package:wechat_flutter/im/im_handle/im_msg_api.dart';

var subscription = Connectivity();

typedef Callback(data);
typedef VoidCallbackConfirm = void Function(bool isOk);

DefaultCacheManager cacheManager = new DefaultCacheManager();

const String defGroupAvatar = 'http://www.shenmeniuma.com/mockImg/group.png';

const Color mainBGColor = Color.fromRGBO(240, 240, 245, 1.0);
