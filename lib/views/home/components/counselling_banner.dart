import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/action_button.dart';

class CounsellingBanner extends StatelessWidget {
  const CounsellingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: double.infinity,
      backgroundColor: AppColors.counsellingBannerBg,
      borderRadius: 7,
      padding: const EdgeInsets.fromLTRB(19, 19, 14, 19),
      child: Stack(
        children: [
          // Info button - top right
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.info_outline,
                size: 18,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 20,
            bottom: 0,
            child: SizedBox(
              width: 96,
              child: Image.asset(
                'assets/lottiebanner2.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Your First Counselling Call Awaits',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Get Personalized Guidance\nto Stay on Track',
                maxLines: 3,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              ActionButton(
                text: 'Schedule Now',
                onTap: () {},
                backgroundColor: AppColors.counsellingButton,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
