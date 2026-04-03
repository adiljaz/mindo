import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/responsive_util.dart';
import '../../../widgets/nav_icon_button.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    final logoScale = isDesktop ? 5.0 : (isTablet ? 4.0 : 3.5);
    final logoSize = isDesktop ? 60.0 : (isTablet ? 50.0 : 44.0);
    final buttonSpacing = isDesktop ? 16.0 : (isTablet ? 12.0 : 10.0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: isDesktop ? 24 : 16, top: 10),
          child: Transform.scale(
            scale: logoScale,
            child: Image.asset(
              'assets/app logo.png',
              width: logoSize,
              height: logoSize,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Row(
          children: [
            NavIconButton(
              icon: Icons.phone,
              iconColor: Colors.red,
              onTap: () {},
            ),
            SizedBox(width: buttonSpacing),
            NavIconButton(
              icon: Icons.notifications,
              iconColor: AppColors.primaryBlue,
              badge: true,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
