import 'package:dim/commom/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/config/storage_manager.dart';
import 'package:wechat_flutter/pages/login/login_begin_page.dart';
import 'package:wechat_flutter/pages/root/root_page.dart';
import 'package:wechat_flutter/provider/global_model.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class MyApp extends StatelessWidget {
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
      routes: {
        '/': (context) {
          return model.goToLogin ? new LoginBeginPage() : new RootPage();
        }
      },
    );
  }
}
