import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HudView {
  static bool isLoading = false;
  static bool isAutoShow = false;
  static BuildContext _context;
  static Timer _timer;
  static String icon = 'assets/assets/images/loading.gif';

  /*
  * 定时关闭
  *
  * */
  static void timerTread([int s = 10]) {
    if (_timer != null && _timer.isActive) {
      _timer?.cancel();
      _timer = null;
    }
    int index = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      index++;
      if (index >= s) {
        index = 0;
        timer.cancel();
        dismiss();
      }
    });
  }

  /*
  * 显示
  *
  * */
  static void show(BuildContext context,
      {msg = 'loading...', int second = 10}) {
    if (context == null) {
      return;
    }

    dismiss();

    if (isLoading) {
      return;
    }
    isLoading = true;
    isAutoShow = false;
    _context = context;

    timerTread(second);

    /// Avoid getx no args.
    final oldArguments = Get.arguments;

    Get.dialog(
      WillPopScope(
        child: Container(
          alignment: Alignment.center,
          color: Colors.transparent,
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
                        msg,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        },
      ),
      arguments: oldArguments,
    );
  }

  /*
  * 消散
  *
  * */
  static void dismiss() {
    if (isLoading && _context != null) {
      Navigator.of(_context).pop();
      _context = null;
    }
    isLoading = false;
    isAutoShow = false;
  }
}
