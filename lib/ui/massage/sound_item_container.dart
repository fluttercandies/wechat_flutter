import 'package:flutter/material.dart';

class SoundItemContainer extends StatefulWidget {
  final List<Widget> children;
  final VoidCallback? onPressed;

  SoundItemContainer({required this.children, this.onPressed});

  @override
  _SoundItemContainerState createState() => _SoundItemContainerState();
}

class _SoundItemContainerState extends State<SoundItemContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      padding: EdgeInsets.only(right: 10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.only(left: 8.0, right: 4.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: widget.children,
        ),
        onPressed: widget.onPressed ?? () {},
      ),
    );
  }
}