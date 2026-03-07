import 'package:collection/collection.dart';
import 'package:example/example_routes.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../example_route.dart';
import '../example_routes.dart' as example_routes;

@FFRoute(
  name: 'fluttercandies://mainpage',
  routeName: 'MainPage',
)
class MainPage extends StatelessWidget {
  MainPage() {
    final List<String> routeNames = <String>[];
    routeNames.addAll(example_routes.routeNames);
    routeNames.remove(Routes.fluttercandiesMainpage);
    routeNames.remove(Routes.fluttercandiesDemogrouppage);
    routesGroup.addAll(groupBy<DemoRouteResult, String?>(
        routeNames
            .map<FFRouteSettings>((String name) => getRouteSettings(name: name))
            .where((FFRouteSettings element) => element.exts != null)
            .map<DemoRouteResult>((FFRouteSettings e) => DemoRouteResult(e))
            .toList()
          ..sort((DemoRouteResult a, DemoRouteResult b) =>
              b.group!.compareTo(a.group!)),
        (DemoRouteResult x) => x.group));
  }
  final Map<String?, List<DemoRouteResult>> routesGroup =
      <String?, List<DemoRouteResult>>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('extended_text_field'),
        actions: <Widget>[
          ButtonTheme(
            minWidth: 0.0,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextButton(
              child: const Text(
                'Github',
                style: TextStyle(
                  decorationStyle: TextDecorationStyle.solid,
                  decoration: TextDecoration.underline,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                launchUrl(Uri.parse(
                    'https://github.com/fluttercandies/extended_text_field'));
              },
            ),
          ),
          if (!kIsWeb)
            ButtonTheme(
              padding: const EdgeInsets.only(right: 10.0),
              minWidth: 0.0,
              child: TextButton(
                child: Image.network(
                    'https://pub.idqqimg.com/wpa/images/group.png'),
                onPressed: () {
                  launchUrl(Uri.parse('https://jq.qq.com/?_wv=1027&k=5bcc0gy'));
                },
              ),
            )
        ],
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext c, int index) {
          // final RouteResult page = routes[index];
          final String type = routesGroup.keys.toList()[index]!;
          return Container(
              margin: const EdgeInsets.all(20.0),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      (index + 1).toString() + '.' + type,
                      //style: TextStyle(inherit: false),
                    ),
                    Text(
                      '$type demos of extended_text_field',
                      //page.description,
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.fluttercandiesDemogrouppage,
                    arguments: <String, dynamic>{
                      'keyValue': routesGroup.entries.toList()[index],
                    },
                  );
                },
              ));
        },
        itemCount: routesGroup.length,
      ),
    );
  }
}

@FFRoute(
  name: 'fluttercandies://demogrouppage',
  routeName: 'DemoGroupPage',
)
class DemoGroupPage extends StatelessWidget {
  DemoGroupPage({required MapEntry<String?, List<DemoRouteResult>> keyValue})
      : routes = keyValue.value
          ..sort((DemoRouteResult a, DemoRouteResult b) =>
              a.order!.compareTo(b.order!)),
        group = keyValue.key!;
  final List<DemoRouteResult> routes;
  final String group;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$group demos'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          final DemoRouteResult page = routes[index];
          return Container(
            margin: const EdgeInsets.all(20.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    (index + 1).toString() + '.' + page.routeResult.routeName!,
                    //style: TextStyle(inherit: false),
                  ),
                  Text(
                    page.routeResult.description!,
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, page.routeResult.name!);
              },
            ),
          );
        },
        itemCount: routes.length,
      ),
    );
  }
}

class DemoRouteResult {
  DemoRouteResult(
    this.routeResult,
  )   : order = routeResult.exts!['order'] as int?,
        group = routeResult.exts!['group'] as String?;

  final int? order;
  final String? group;
  final FFRouteSettings routeResult;
}
