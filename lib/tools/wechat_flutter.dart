export 'dart:ui';
export 'dart:async';
export 'package:flutter/services.dart';
export 'dart:io';
export 'package:dim/dim.dart';
export 'package:cached_network_image/cached_network_image.dart';
export 'package:connectivity/connectivity.dart';
export 'package:dim_example/ui/bar/commom_bar.dart';
export 'package:dim_example/config/const.dart';
export 'package:dim_example/ui/button/commom_button.dart';
export 'package:dim_example/generated/i18n.dart';
export 'package:dim_example/ui/dialog/show_snack.dart';
export 'package:dim_example/ui/dialog/show_toast.dart';
export 'package:dim_example/ui/view/main_input.dart';
export 'package:dim_example/config/contacts.dart';
export 'package:dim_example/config/strings.dart';
export 'package:dim_example/tools/shared_util.dart';
export 'package:dim_example/ui/web/web_view.dart';
export 'package:dim_example/ui/view/loading_view.dart';
export 'package:dim_example/ui/view/image_view.dart';
export 'package:dim_example/config/api.dart';
export 'package:dim_example/http/req.dart';
export 'package:dim_example/tools/data/data.dart';
export 'package:dim_example/ui/view/null_view.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dim/dim.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Dim im = new Dim();

var subscription = Connectivity();

typedef Callback(data);

DefaultCacheManager cacheManager = new DefaultCacheManager();
