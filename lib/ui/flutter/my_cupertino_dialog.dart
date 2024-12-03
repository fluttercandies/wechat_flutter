import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

const TextStyle _kCupertinoDialogTitleStyle = TextStyle(
  fontFamily: '.SF UI Display',
  inherit: false,
  fontSize: 18.0,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.48,
  textBaseline: TextBaseline.alphabetic,
);

const TextStyle _kCupertinoDialogContentStyle = TextStyle(
  fontFamily: '.SF UI Text',
  inherit: false,
  fontSize: 13.4,
  fontWeight: FontWeight.w400,
  height: 1.036,
  letterSpacing: -0.25,
  textBaseline: TextBaseline.alphabetic,
);

const TextStyle _kCupertinoDialogActionStyle = TextStyle(
  fontFamily: '.SF UI Text',
  inherit: false,
  fontSize: 16.8,
  fontWeight: FontWeight.w400,
  textBaseline: TextBaseline.alphabetic,
);

const double _kCupertinoDialogWidth = 270.0;
const double _kAccessibilityCupertinoDialogWidth = 310.0;

const double _kBlurAmount = 20.0;
const double _kEdgePadding = 20.0;
const double _kMinButtonHeight = 45.0;
const double _kMinButtonFontSize = 10.0;
const double _kDialogCornerRadius = 14.0;
const double _kDividerThickness = 1.0;

const Color _kDialogColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xCCF2F2F2),
  darkColor: Color(0xBF1E1E1E),
);

const Color _kDialogPressedColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFE1E1E1),
  darkColor: Color(0xFF2E2E2E),
);

const double _kMaxRegularTextScaleFactor = 1.4;

bool _isInAccessibilityMode(BuildContext context) {
  final MediaQueryData data = MediaQuery.of(context);
  return data.textScaleFactor > _kMaxRegularTextScaleFactor;
}

class MyCupertinoAlertDialog extends StatelessWidget {
  const MyCupertinoAlertDialog({
    Key? key,
    this.title,
    this.content,
    required this.actions,
    this.scrollController,
    this.actionScrollController,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
  }) : super(key: key);

  final Widget? title;
  final Widget? content;
  final List<Widget> actions;
  final ScrollController? scrollController;
  final ScrollController? actionScrollController;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;

  Widget _buildContent(BuildContext context) {
    return Container(
      color: CupertinoDynamicColor.resolve(_kDialogColor, context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (title != null) Padding(
            padding: const EdgeInsets.all(_kEdgePadding),
            child: DefaultTextStyle(
              style: _kCupertinoDialogTitleStyle,
              textAlign: TextAlign.center,
              child: title!,
            ),
          ),
          if (content != null) Padding(
            padding: const EdgeInsets.symmetric(horizontal: _kEdgePadding),
            child: DefaultTextStyle(
              style: _kCupertinoDialogContentStyle,
              textAlign: TextAlign.center,
              child: content!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return _CupertinoAlertActionSection(
      children: actions,
      scrollController: actionScrollController,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isInAccessibilityMode = _isInAccessibilityMode(context);
    final double dialogWidth = isInAccessibilityMode
        ? _kAccessibilityCupertinoDialogWidth
        : _kCupertinoDialogWidth;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: math.min(MediaQuery.of(context).textScaleFactor, 1.4),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            child: Container(
              width: dialogWidth,
              child: CupertinoPopupSurface(
                isSurfacePainted: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: _buildContent(context),
                    ),
                    _buildActions(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CupertinoAlertActionSection extends StatelessWidget {
  const _CupertinoAlertActionSection({
    Key? key,
    required this.children,
    this.scrollController,
  }) : super(key: key);

  final List<Widget> children;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}