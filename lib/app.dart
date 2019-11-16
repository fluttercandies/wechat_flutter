import 'package:dim/commom/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:dim_example/config/storage_manager.dart';
import 'package:dim_example/pages/login/login_begin_page.dart';
import 'package:dim_example/pages/root/root_page.dart';
import 'package:dim_example/provider/global_model.dart';
import 'package:dim_example/tools/wechat_flutter.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      StorageManager().initAutoLogin();
    } else {
      debugPrint('IOS自动登陆开发中');
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GlobalModel>(context)..setContext(context);

    return new MaterialApp(
      navigatorKey: navGK,
      title: model.appName,
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        hintColor: Colors.grey.withOpacity(0.3),
        splashColor: Colors.transparent,
        canvasColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        S.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: model.currentLocale,
      home: model.goToLogin ? new LoginBeginPage() : new RootPage(),
    );
  }
}
