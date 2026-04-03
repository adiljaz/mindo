import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/responsive_util.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/action_button.dart';

class SessionBannerCard extends StatelessWidget {
  const SessionBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    final cardHeight = isDesktop ? 160.0 : (isTablet ? 145.0 : 130.0);
    final titleFontSize = isDesktop ? 18.0 : (isTablet ? 16.0 : 15.0);
    final subtitleFontSize = isDesktop ? 14.0 : (isTablet ? 13.0 : 12.0);
    final imageSize = isDesktop ? 100.0 : (isTablet ? 90.0 : 80.0);

    return AppCard(
      height: cardHeight,
      padding: EdgeInsets.only(
        top: isDesktop ? 24 : 20,
        left: isDesktop ? 24 : 20,
        right: isDesktop ? 24 : 20,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'No Sessions Scheduled Today',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A2E),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                'Talk to a Listener and Feel Better',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: subtitleFontSize,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              ActionButton(
                text: 'Start Session',
                onTap: () {},
                backgroundColor: AppColors.primaryBlue,
                borderRadius: 30,
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      'View Plans',
                      style: TextStyle(
                        fontSize: isDesktop ? 12 : 10,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: isDesktop ? 16 : 14,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: isDesktop ? -100 : -130,
            left: isDesktop ? 50 : 30,
            top: isDesktop ? 20 : 28,
            child: Image.asset(
              'assets/bannerlogonew.png',
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
