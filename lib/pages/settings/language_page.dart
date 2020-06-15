import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_flutter/provider/global_model.dart';
import 'package:wechat_flutter/tools/shared_util.dart';

import 'package:wechat_flutter/tools/wechat_flutter.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final List<LanguageData> languageDatas = [
    LanguageData("中文", "zh", "CN", "微信-flutter"),
    LanguageData("English", "en", "US", "Wechat-flutter"),
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
          onChanged: (value) {
            model.currentLanguageCode = [languageCode, countryCode];
            model.currentLanguage = language;
            model.currentLocale = Locale(languageCode, countryCode);
            model.appName = appName;
            model.refresh();
            SharedUtil.instance.saveStringList(
                Keys.currentLanguageCode, [languageCode, countryCode]);
            SharedUtil.instance.saveString(Keys.currentLanguage, language);
            SharedUtil.instance.saveString(Keys.appName, appName);
          },
          title: new Text(languageDatas[index].language),
        );
      }),
    );
    return new Scaffold(
      appBar: new ComMomBar(title: S.of(context).multiLanguage),
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
