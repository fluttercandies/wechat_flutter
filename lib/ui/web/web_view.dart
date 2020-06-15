import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat_flutter/ui/bar/commom_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  WebViewPage(this.url, this.title);

  @override
  State<StatefulWidget> createState() => new WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _controller =
      new Completer<WebViewController>();

  Widget body() {
    return new Builder(builder: (BuildContext context) {
      return new WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        javascriptChannels: <JavascriptChannel>[
          _toasterJavascriptChannel(context),
        ].toSet(),
        navigationDelegate: (NavigationRequest request) {
          if (request.url
              .startsWith('https://github.com/fluttercandies/wechat_flutter')) {
            print('blocking navigation to $request}');
            return NavigationDecision.prevent;
          }
          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new ComMomBar(
          title: '${widget.title}', leadingImg: 'assets/images/bar_close.png'),
      body: body(),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return new JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        Scaffold.of(context).showSnackBar(
          new SnackBar(content: Text(message.message)),
        );
      },
    );
  }
}
