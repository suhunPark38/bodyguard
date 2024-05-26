import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Text text;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: onPressed != null
            ? Colors.white
            : Colors.grey, backgroundColor: onPressed != null
            ? Theme.of(context).primaryColor
            : Colors.grey, shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ), // Set the text color based on whether the button is enabled
      ),
      child: text,
    );
  }
}
