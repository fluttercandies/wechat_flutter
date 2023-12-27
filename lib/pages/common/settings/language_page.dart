import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/tools/provider/global_model.dart';
import 'package:wechat_flutter/tools/config/app_config.dart';
import 'package:wechat_flutter/tools/func/shared_util.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final List<LanguageData> languageDatas = [
    LanguageData("中文", "zh", "CN", "${AppConfig.appName}"),
    LanguageData("English", "en", "US", "${AppConfig.appName}"),
  ];

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<GlobalModel>(context);

    var body = new ListView(
      children: new List.generate(languageDatas.length, (index) {
        final String languageCode = languageDatas[index].languageCode;
        final String countryCode = languageDatas[index].countryCode;
        final String language = languageDatas[index].language;
        final String appName = languageDatas[index].appName;
        return new RadioListTile(
          value: language,
          groupValue: model.currentLanguage,
          onChanged: (dynamic value) {
            model.setCurrentLanguageCode([languageCode, countryCode]);
            model.setCurrentLanguage(language);
            model.setCurrentLocale(Locale(languageCode, countryCode));
            model.setAppName(appName);
            model.refresh();
            SharedUtil.instance!.saveStringList(
                Keys.currentLanguageCode, [languageCode, countryCode]);
            SharedUtil.instance!.saveString(Keys.currentLanguage, language);
            SharedUtil.instance!.saveString(Keys.appName, appName);
          },
          title: new Text(languageDatas[index].language),
        );
      }),
    );
    return new Scaffold(
      appBar: new ComMomBar(title: "多语言"),
      body: body,
    );
  }
}

class LanguageData {
  String language;
  String languageCode;
  String countryCode;
  String appName;

  LanguageData(
      this.language, this.languageCode, this.countryCode, this.appName);
}
