import 'package:flutter/material.dart';

enum FilterType {
  all,
  oneWeek,
  oneMonth,
  custom
}

class FilterButton extends StatelessWidget {
  final FilterType filterType;
  final VoidCallback onPressed;
  final bool isSelected;
  final String buttonText;
  final double buttonWidth;
  final double buttonHeight;
  final double textSize;

  const FilterButton({
    Key? key,
    required this.filterType,
    required this.onPressed,
    required this.isSelected,
    required this.buttonText,
    this.buttonWidth = 90.0,
    this.buttonHeight = 20.0,
    this.textSize = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: isSelected
            ? FilledButton(
                onPressed: onPressed,
                child: Text(buttonText, style: TextStyle(fontSize: textSize),),
              )
            : OutlinedButton(
                onPressed: onPressed,
                child: Text(buttonText,  style: TextStyle(fontSize: textSize),),
              ));
  }
}
