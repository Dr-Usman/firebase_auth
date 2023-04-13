import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, this.title, this.onTap});
  final String? title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(
        title ?? '',
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
