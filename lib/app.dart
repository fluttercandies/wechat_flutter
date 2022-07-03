import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/im/im_handle/Im_api.dart';
import 'package:wechat_flutter/pages/login/login_begin_page.dart';
import 'package:wechat_flutter/pages/root/root_page.dart';
import 'package:wechat_flutter/provider/global_model.dart';
import 'package:wechat_flutter/provider/im/im_event.dart';
import 'package:wechat_flutter/provider/im/im_notice.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GlobalModel>(context)..setContext(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IMNotice()),
        ChangeNotifierProvider(create: (_) => IMEvent()),
      ],
      child: new GetMaterialApp(
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
            return StartPage(model);
          }
        },
      ),
    );
  }
}

class StartPage extends StatefulWidget {
  final GlobalModel model;

  const StartPage(this.model, {Key key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isInitOk = false;

  @override
  void initState() {
    super.initState();
    init();
  }

/*
* 初始化
* */
  Future init() async {
    await ImApi.init(context);

    await ImApi.checkLogin();
    isInitOk = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitOk) {
      return Material(
        color: Colors.white,
        child: Center(child: Text('加载中')),
      );
    }
    return widget.model.goToLogin ? new LoginBeginPage() : new RootPage();
  }
}
