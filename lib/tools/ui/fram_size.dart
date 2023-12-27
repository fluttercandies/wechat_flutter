/*
* num扩展方法
* */
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension FrameSizeNum on num {
  double get px {
    return FrameSize.px(this);
  }
}

class FrameSize {
  FrameSize();

  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
  static final double _width = mediaQuery.size.width;
  static final double _height = mediaQuery.size.height;
  static final double _topBarH = mediaQuery.padding.top;
  static final double _botBarH = mediaQuery.padding.bottom;
  static final double _pixelRatio = mediaQuery.devicePixelRatio;
  static double? _ratio;

  static void init(int number) {
    final int uiWidth = number;
    _ratio = _width / uiWidth;
  }

  /// 适配方式：实际值 *（屏幕宽度 / 375【设计稿宽度】）
  static double px(num number) {
    if (kIsWeb) {
      return number.toDouble();
    }
    if (!(_ratio is double || _ratio is int)) {
      FrameSize.init(375);
    }

    return number * (_ratio ?? 0);
  }

  /*
  * 当横屏时获取的值还是竖屏的
  * */
  static double screenW() {
    return _width;
  }

  /*
  * 当横屏时获取的值还是竖屏的
  * */
  static double screenH() {
    return _height;
  }

  static bool isHorizontal() {
    return winWidth() > winHeight();
  }

  /*
  * 取宽高里面的最大值，
  * 如果宽大于高那就使用宽
  * 如果高大于宽那就使用高
  * */
  static double maxValue() {
    final maxValue = isHorizontal() ? winWidth() : winHeight();

    return maxValue;
  }

  /*
  * 取宽高里面的最小值，
  * */
  static double minValue() {
    final minValue = isHorizontal() ? winHeight() : winWidth();

    return minValue;
  }

  static bool isNeedRotate() {
    return !kIsWeb && isHorizontal();
  }

  /// 屏幕宽度[横屏需要]
  static double winWidth() {
    final MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    return mediaQuery.size.width;
  }

  /// 屏幕高度[横屏需要]
  static double winHeight() {
    final MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
    return mediaQuery.size.height;
  }

  /// 屏幕宽度[横屏需要]-动态-横竖屏转换会变化
  /// 会影响到上下文
  static double winWidthDynamic(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// 屏幕高度[横屏需要]-动态-横竖屏转换会变化
  /// 会影响到上下文
  static double winHeightDynamic(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// 键盘高度
  /// 如果为0则是键盘未弹出
  static double winKeyHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  /// 状态栏高度
  static double statusBarHeight() {
    return MediaQueryData.fromWindow(window).padding.top;
  }

  /// navigationBar高度
  static double navigationBarHeight() {
    return kToolbarHeight;
  }

  /// 整AppBar高度
  /// 状态栏高度 + navigationBar高度
  static double topBarHeight() {
    return navigationBarHeight() + statusBarHeight();
  }

  static double padTopH() {
    return _topBarH;
  }

  static double padTopHDynamic(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// 【2021 12.28】优惠券图标适配有左右安全区时
  /// 获取安全区右边间距
  static double padRight() {
    return MediaQueryData.fromWindow(window).padding.right;
  }

  /// 【2021 12.28】优惠券图标适配有左右安全区时
  /// /// 获取安全区左边间距
  static double padLeft() {
    return MediaQueryData.fromWindow(window).padding.left;
  }

  static double padBotH() {
    return _botBarH;
  }

  static double pixelRatio() {
    return _pixelRatio;
  }
}


/*
* num扩展方法
* */
extension ScreenUtilNum on num {
  /// 根据设计稿的设备高度适配【简单用法】
  /// 例子：
  /// fontSize: 10.f
  double get f {
    return ScreenUtil.f(this);
  }

  /// 根据设计稿的设备高度适配【简单用法】
  /// 例子：
  /// height: 10.h
  double get h {
    return ScreenUtil.h(this);
  }

  /// 根据设计稿的设备宽度适配【简单用法】
  /// 例子：
  /// width: 10.w
  double get w {
    return ScreenUtil.w(this);
  }
}

class ScreenUtil {
  //设计稿的设备尺寸修改
  static int width = 375;
  static int height = 812;
  static bool allowFontScaling = true;

  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);

  static double _pixelRatio = mediaQuery.devicePixelRatio;
  static double _screenWidth = mediaQuery.size.width;
  static double _screenHeight = mediaQuery.size.height;
  static double _statusBarHeight = mediaQuery.padding.top;
  static double _bottomBarHeight = mediaQuery.padding.bottom;
  static final double _textScaleFactor = mediaQuery.textScaleFactor;

  ///每个逻辑像素的字体像素数，字体的缩放比例
  static double get textScaleFactory => _textScaleFactor;

  ///设备的像素密度
  static double get pixelRatio => _pixelRatio;

  ///当前设备宽度 dp
  static double get screenWidthDp => _screenWidth;

  ///当前设备高度 dp
  static double get screenHeightDp => _screenHeight;

  ///当前设备宽度 px
  static double get screenWidth => _screenWidth * _pixelRatio;

  ///当前设备高度 px
  static double get screenHeight => _screenHeight * _pixelRatio;

  ///状态栏高度 刘海屏会更高
  static double get statusBarHeight => _statusBarHeight * _pixelRatio;

  ///底部安全区距离
  static double get bottomBarHeight => _bottomBarHeight * _pixelRatio;

  ///实际的dp与设计稿px的比例
  static get scaleWidth => _screenWidth / width;

  static get scaleHeight => _screenHeight / height;

  static double winWidth() {
    return screenWidth;
  }

  static double winHeight() {
    return screenHeight;
  }

  /*
  * 设置新宽高尺寸
  * */
  static void setWindow(ViewConfiguration viewConfiguration) {
    _pixelRatio = viewConfiguration.devicePixelRatio;
    _screenWidth = viewConfiguration.geometry.width / _pixelRatio;
    _screenHeight = viewConfiguration.geometry.height / _pixelRatio;
    _statusBarHeight = viewConfiguration.padding.top;
    _bottomBarHeight = viewConfiguration.padding.bottom;
  }

  ///根据设计稿的设备宽度适配
  ///高度也根据这个来做适配可以保证不变形
  static w(num width) {
    if (width == null) return null;
    return width * scaleWidth;
  }

  /// 根据设计稿的设备高度适配
  /// 当发现设计稿中的一屏显示的与当前样式效果不符合时,
  /// 或者形状有差异时,高度适配建议使用此方法
  /// 高度适配主要针对想根据设计稿的一屏展示一样的效果
  static h(num height) {
    if (height == null) return null;
    return height * scaleHeight;
  }

  ///字体大小适配方法
  ///@param fontSize 传入设计稿上字体的px ,
  ///@param allowFontScaling 控制字体是否要根据系统的“字体大小”辅助选项来进行缩放。默认值为true。
  ///@param allowFontScaling Specifies whether fonts should scale to respect Text Size accessibility settings. The default is true.
  static f(num fontSize) {
//    print('allowFontScaling == $allowFontScaling');
    return allowFontScaling ? w(fontSize) : w(fontSize) / _textScaleFactor;
  }

  static lineHeight(num fontSize) {
//    print('allowFontScaling == $allowFontScaling');
    return w(fontSize) / _textScaleFactor * 1.2;
  }

  /// 键盘高度
  /// 如果为0则是键盘未弹出
  static double winKeyHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }
}

