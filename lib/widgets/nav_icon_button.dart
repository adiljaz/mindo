import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class NavIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final bool badge;
  final VoidCallback onTap;

  const NavIconButton({
    super.key,
    required this.icon,
    required this.iconColor,
    this.badge = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: iconColor, size: 22),
            if (badge)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
