import 'package:flutter/material.dart';


class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onPressed;
  final String? hintText;

  const CustomSearchBar({super.key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onPressed,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey), // 힌트 텍스트 색상 지정
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: onPressed,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,

      ),
    );
  }
}
