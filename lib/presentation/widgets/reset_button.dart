import 'package:flutter/material.dart';

class ResetButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double iconSize;
  final double fontSize;
  final Color color;

  const ResetButton({
    Key? key,
    required this.onPressed,
    this.iconSize = 20.0,
    this.fontSize = 14.0,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        Icons.refresh,
        size: iconSize,
        color: color,
      ),
      label: Text(
        'Làm mới',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
