import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final IconData? icon;
  final double fontSize;
  final FontWeight fontWeight;

  const ActionButton({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor = AppColors.primaryBlue,
    this.textColor = AppColors.white,
    this.width,
    this.height,
    this.borderRadius = 30,
    this.icon,
    this.fontSize = 13,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: 16),
              const SizedBox(width: 6),
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: fontWeight,
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
