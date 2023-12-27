import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HudView {
  static bool isLoading = false;
  static bool isAutoShow = false;
  static OverlayEntry? overlayEntry = OverlayEntry(builder: (context) {
    return Container();
  });
  static BuildContext? _context;
  static Timer? _timer;
  static String icon = 'assets/images/loading.gif';

  /*
  * 定时关闭
  *
  * */
  static void timerTread([int s = 5, VoidCallback? onTimeOut]) {
    if (_timer != null && _timer!.isActive) {
      _timer?.cancel();
      _timer = null;
    }
    int index = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      index++;
      if (index >= s) {
        index = 0;
        timer.cancel();
        if (onTimeOut != null && isLoading) {
          onTimeOut();
        }
        dismiss();
      }
    });
  }

  /*
  * 显示自定义的Widget
  *
  * */
  static void showWidget(BuildContext context,
      {required Widget child, int second = 3}) {
    if (context == null) {
      return;
    }

    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      dismiss();

      if (isLoading) {
        return;
      }
      isLoading = true;
      isAutoShow = false;
      _context = context;

      timerTread(second);

      overlayEntry = OverlayEntry(
        builder: (context) {
          return Center(
            child: Material(type: MaterialType.transparency, child: child),
          );
        },
      );

      if (overlayEntry != null) {
        Overlay.of(_context!)!.insert(overlayEntry!);
      }
    });
  }

  /*
  * 显示
  *
  * */
  static void show(BuildContext? context,
      {String? msg, int second = 10, VoidCallback? onTimeOut}) {
    if (context == null) {
      return;
    }

    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      dismiss();

      if (isLoading) {
        return;
      }
      isLoading = true;
      isAutoShow = false;
      _context = context;

      timerTread(second, onTimeOut);

      overlayEntry = OverlayEntry(
        builder: (context) {
          return Center(
            child: Material(
              type: MaterialType.transparency,
              textStyle: const TextStyle(color: Color(0xFF212121)),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
                width: 90.0,
                height: 90.0,
                alignment: Alignment.center,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Image.asset(icon),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text(
                          msg ?? "加载中...",
                          style: const TextStyle(color: Colors.white),
                          maxLines: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

      if (overlayEntry != null) {
        try {
          Overlay.of(_context!)!.insert(overlayEntry!);
        } catch (e) {
          debugPrint("HudView出现错误::Overlay.of(_context).insert(overlayEntry);");
        }
      }
    });
  }

  /*
  * 消散
  *
  * */
  static void dismiss() {
    if (isLoading && overlayEntry != null && _context != null) {
      try {
        if (overlayEntry != null) overlayEntry?.remove();
      } catch (e) {
        debugPrint("HudView出现错误::remove");
      }
      overlayEntry = null;
    }
    isLoading = false;
    isAutoShow = false;
  }

  /*
  * 自动显示
  *
  * */
  static void autoShow(BuildContext context, {String? msg}) {
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      dismiss();

      if (isLoading) {
        return;
      }

      isLoading = true;
      isAutoShow = true;
      _context = context;

      timerTread();

      overlayEntry ??= OverlayEntry(
        builder: (context) {
          return Center(
            child: Material(
              type: MaterialType.transparency,
              textStyle: const TextStyle(color: Color(0xFF212121)),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(4.0)),
                  color: const Color.fromRGBO(0, 0, 0, 0.3),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
                width: 90.0,
                height: 90.0,
                alignment: Alignment.center,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Image.asset(icon),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text(
                          msg ?? "加载中...",
                          style: const TextStyle(color: Colors.white),
                          maxLines: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

      Overlay.of(_context!)!.insert(overlayEntry!);
    });
  }

  /*
  * 自动消散
  *
  * */
  static void autoDismiss() {
    if (isAutoShow) {
      if (isLoading && overlayEntry != null) {
        try {
          overlayEntry?.remove();
        } catch (e) {
          debugPrint("HudView出现错误::overlayEntry?.remove();");
        }
        overlayEntry = null;
      }
      isLoading = false;
    } else {
      isAutoShow = false;
    }
  }
}
