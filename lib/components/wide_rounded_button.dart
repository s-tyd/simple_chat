import 'package:flutter/material.dart';

typedef WideRoundedCallBack = void Function();

class WideRoundedButton extends StatelessWidget {
  const WideRoundedButton({
    required this.title,
    required this.onPressed,
    this.color,
    super.key,
  });

  final WideRoundedCallBack onPressed;
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: const Size.fromWidth(double.maxFinite),
        foregroundColor: Colors.white,
        backgroundColor: color ?? Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
