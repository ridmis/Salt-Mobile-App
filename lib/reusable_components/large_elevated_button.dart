import 'package:flutter/material.dart';
import 'package:myapp/constant.dart';

class LargeElevatedButton extends StatelessWidget {
  final String title;
  final Color? color;
  final VoidCallback? onPressed;
  const LargeElevatedButton({
    super.key,
    required this.title,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(330, 50),
        backgroundColor: color ?? blueColor1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onPressed,
      child: Text(title, style: buttonTextStyle),
    );
  }
}
