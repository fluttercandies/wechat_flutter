import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  const ToggleButton({
    this.activeChanged,
    this.active = false,
    super.key,
    required this.builder,
  });

  final bool active;
  final ValueChanged<bool>? activeChanged;
  final Widget Function(bool active) builder;
  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool _active = false;

  @override
  void initState() {
    _active = widget.active;
    super.initState();
  }

  @override
  void didUpdateWidget(ToggleButton oldWidget) {
    _active = widget.active;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          _active = !_active;
          widget.activeChanged?.call(_active);
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
        child: widget.builder(_active),
      ),
    );
  }
}
