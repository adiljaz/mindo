import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class SeeAllLink extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final double fontSize;

  const SeeAllLink({
    super.key,
    required this.onTap,
    this.text = 'See All',
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.arrow_forward, size: fontSize + 5, color: AppColors.primaryBlue),
        ],
      ),
    );
  }
}
