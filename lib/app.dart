import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/pages/common/login/login_begin_page.dart';
import 'package:wechat_flutter/pages/root/root/root_logic.dart';
import 'package:wechat_flutter/pages/root/root/root_view.dart';
import 'package:wechat_flutter/tools/core/global_controller.dart';
import 'package:wechat_flutter/tools/provider/global_model.dart';
import 'package:wechat_flutter/tools/provider/im/im_event.dart';
import 'package:wechat_flutter/tools/wechat_flutter.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      dismissOtherOnShow: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => IMEvent()),
        ],
        child: new GetMaterialApp(
          title: AppConfig.appName,
          theme: ThemeData(
            scaffoldBackgroundColor: bgColor,
            hintColor: Colors.grey.withOpacity(0.3),
            splashColor: Colors.transparent,
            canvasColor: Colors.transparent,
            primaryColor: MyTheme.themeColor(),
            primarySwatch: MyTheme.primarySwatch(),
            textTheme: TextTheme(
              bodyText1: TextStyle(color: Colors.red),
            ),
          ),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          getPages: AppPages.routes,
          initialBinding: InitBinding(),
          initialRoute: RouteConfig.startPage,
        ),
      ),
    );
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<GlobalController>(GlobalController());
    Get.put<RootLogic>(RootLogic());
  }
}

class StartPage extends StatefulWidget {
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
    /// 这个方法里面有检测登录
    await ImApi.init(context);
    isInitOk = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    GlobalModel globalModel = Provider.of<GlobalModel>(context)
      ..setContext(context);

    if (!isInitOk) {
      return Material(
        color: Colors.white,
        child: Center(child: Text('加载中')),
      );
    }
    return globalModel.goToLogin ? new LoginBeginPage() : new RootPage();
  }
}
