import 'package:flutter/material.dart';

class NumberButton extends StatelessWidget {
  const NumberButton({
    Key? key,
    required this.number,
    required this.insertText,
  }) : super(key: key);
  final int number;
  final Function(String text) insertText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        insertText('$number');
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          '$number',
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.child,
    required this.onTap,
  }) : super(key: key);
  final Widget child;
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
