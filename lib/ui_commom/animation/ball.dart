import 'dart:math' as math;

import 'package:flutter/material.dart';

///
/// desc:小球脉冲效果
///
class BallPulseLoading extends StatefulWidget {
  final BallStyle? ballStyle;
  final Duration duration;
  final Curve curve;

  const BallPulseLoading({
    Key? key,
    this.ballStyle,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.linear,
    this.padding = const EdgeInsets.symmetric(horizontal: 3),
  }) : super(key: key);

  final EdgeInsets padding;

  @override
  BallPulseLoadingState createState() => BallPulseLoadingState();
}

class BallPulseLoadingState extends State<BallPulseLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();

    _animation = _controller.drive(CurveTween(curve: widget.curve));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Padding(
          padding: widget.padding,
          child: ScaleTransition(
            scale: DelayTween(begin: 0.0, end: 1.0, delay: index * .2)
                .animate(_animation),
            child: Ball(
              style: widget.ballStyle,
            ),
          ),
        );
      }),
    );
  }
}

///
/// desc:
///
class DelayTween extends Tween<double> {
  final double delay;

  DelayTween({required double begin, required double end, required this.delay})
      : super(begin: begin, end: end);

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}

///
/// 球的样式
///
class BallStyle {
  ///
  /// 尺寸
  ///
  final double size;

  ///
  /// 实心球颜色
  ///
  final Color color;

  ///
  /// 球的类型 [ BallType ]
  ///
  final BallType ballType;

  ///
  /// 边框宽
  ///
  final double borderWidth;

  ///
  /// 边框颜色
  ///
  final Color borderColor;

  const BallStyle(
      {required this.size,
      required this.color,
      required this.ballType,
      required this.borderWidth,
      required this.borderColor});

  BallStyle copyWith(
      {double? size,
      Color? color,
      BallType? ballType,
      double? borderWidth,
      Color? borderColor}) {
    return BallStyle(
        size: size ?? this.size,
        color: color ?? this.color,
        ballType: ballType ?? this.ballType,
        borderWidth: borderWidth ?? this.borderWidth,
        borderColor: borderColor ?? this.borderColor);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is BallStyle &&
        other.size == size &&
        other.color == color &&
        other.ballType == ballType &&
        other.borderWidth == borderWidth &&
        other.borderColor == borderColor;
  }
}

///
/// 默认球的样式
///
const kDefaultBallStyle = BallStyle(
  size: 10.0,
  color: Colors.white,
  ballType: BallType.solid,
  borderWidth: 0.0,
  borderColor: Colors.white,
);

///
/// desc:球
///
class Ball extends StatelessWidget {
  ///
  /// 球样式
  ///
  final BallStyle? style;

  const Ball({
    Key? key,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BallStyle ballStyle = kDefaultBallStyle.copyWith(
        size: style?.size,
        color: style?.color,
        ballType: style?.ballType,
        borderWidth: style?.borderWidth,
        borderColor: style?.borderColor);

    return SizedBox(
      width: ballStyle.size,
      height: ballStyle.size,
      child: DecoratedBox(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                ballStyle.ballType == BallType.solid ? ballStyle.color : null,
            border: Border.all(
                color: ballStyle.borderColor, width: ballStyle.borderWidth)),
      ),
    );
  }
}

enum BallType {
  ///
  /// 空心
  ///
  hollow,

  ///
  /// 实心
  ///
  solid
}
