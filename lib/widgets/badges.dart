import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class OnlineBadge extends StatelessWidget {
  final double size;
  final Color color;
  final bool showBorder;
  final double borderWidth;

  const OnlineBadge({
    super.key,
    this.size = 12,
    this.color = AppColors.successGreen,
    this.showBorder = true,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(color: AppColors.white, width: borderWidth)
            : null,
      ),
    );
  }
}

class PhoneBadge extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final Color iconColor;
  final double borderWidth;

  const PhoneBadge({
    super.key,
    this.size = 26,
    this.backgroundColor = AppColors.onlineGreen,
    this.iconColor = AppColors.white,
    this.borderWidth = 2.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withAlpha(100),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        Icons.phone,
        size: size * 0.58,
        color: iconColor,
      ),
    );
  }
}
