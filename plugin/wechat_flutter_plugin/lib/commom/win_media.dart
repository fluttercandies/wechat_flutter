
import 'dart:ui';

import 'package:flutter/material.dart';

double winWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double winHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double winTop(BuildContext context) {
  return MediaQuery.of(context).padding.top;
}

double winBottom(BuildContext context) {
  return MediaQuery.of(context).padding.bottom;
}

double winLeft(BuildContext context) {
  return MediaQuery.of(context).padding.left;
}

double winRight(BuildContext context) {
  return MediaQuery.of(context).padding.right;
}

double winKeyHeight(BuildContext context) {
  return MediaQuery.of(context).viewInsets.bottom;
}

double statusBarHeight(BuildContext context) {
  return MediaQueryData.fromWindow(window).padding.top;
}

double navigationBarHeight(BuildContext context) {
  return kToolbarHeight;
}

double topBarHeight(BuildContext context) {
  return kToolbarHeight + MediaQueryData.fromWindow(window).padding.top;
}
