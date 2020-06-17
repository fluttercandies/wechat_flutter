export 'dart:ui';
export 'dart:async';
export 'package:flutter/services.dart';
export 'dart:io';
export 'package:dim/dim.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:connectivity/connectivity.dart';
export 'package:wechat_flutter/ui/bar/commom_bar.dart';
export 'package:wechat_flutter/config/const.dart';
export 'package:wechat_flutter/ui/button/commom_button.dart';
export 'package:wechat_flutter/generated/i18n.dart';
export 'package:wechat_flutter/ui/dialog/show_snack.dart';
export 'package:wechat_flutter/ui/dialog/show_toast.dart';
export 'package:wechat_flutter/ui/view/main_input.dart';
export 'package:wechat_flutter/config/contacts.dart';
export 'package:wechat_flutter/config/strings.dart';
export 'package:wechat_flutter/tools/shared_util.dart';
export 'package:wechat_flutter/ui/web/web_view.dart';
export 'package:wechat_flutter/ui/view/loading_view.dart';
export 'package:wechat_flutter/ui/view/image_view.dart';
export 'package:wechat_flutter/config/api.dart';
export 'package:wechat_flutter/http/req.dart';
export 'package:wechat_flutter/tools/data/data.dart';
export 'package:wechat_flutter/ui/view/null_view.dart';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:dim/dim.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Dim im = new Dim();

var subscription = Connectivity();

typedef Callback(data);

DefaultCacheManager cacheManager = new DefaultCacheManager();

const String defGroupAvatar =
    'http://www.flutterj.com/content/uploadfile/zidingyi/g.png';

const Color mainBGColor = Color.fromRGBO(240, 240, 245, 1.0);
