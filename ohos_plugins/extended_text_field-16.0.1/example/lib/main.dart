import 'package:example/pages/simple/no_keyboard.dart';
import 'package:extended_keyboard/extended_keyboard.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'example_route.dart';
import 'example_routes.dart';

Future<void> main() async {
  CustomKeyboarBinding();
  await SystemKeyboard().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //EditableText
    //TextField
    return OKToast(
      child: MaterialApp(
        title: 'extended_text_field demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: Routes.fluttercandiesMainpage,
        onGenerateRoute: (RouteSettings settings) {
          return onGenerateRoute(
            settings: settings,
            getRouteSettings: getRouteSettings,
          );
        },
      ),
    );
  }
}
