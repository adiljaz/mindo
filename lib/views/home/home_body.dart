import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../utils/responsive_util.dart';
import 'components/top_bar.dart';
import 'components/session_banner_card.dart';
import 'components/mood_checkin_card.dart';
import 'components/listener_section.dart';
import 'components/talk_randomly_button.dart';
import 'components/feature_banner.dart';
import 'components/care_units_section.dart';
import 'components/counselling_banner.dart';
import 'components/corporate_programs_section.dart';

class HomeBody extends StatelessWidget {
  final int? selectedMood;
  final ValueChanged<int> onMoodSelected;

  const HomeBody({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    final horizontalPadding = isDesktop ? 40.0 : (isTablet ? 30.0 : 20.0);
    final greetingFontSize = isDesktop ? 28.0 : (isTablet ? 22.0 : 18.0);
    final questionFontSize = isDesktop ? 18.0 : (isTablet ? 14.0 : 11.0);
    final sectionSpacing = isDesktop ? 32.0 : (isTablet ? 26.0 : 20.0);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        16,
        horizontalPadding,
        100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopBar(),
          const SizedBox(height: 10),
          Text(
            AppConstants.greeting,
            style: TextStyle(
              fontSize: greetingFontSize,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
              letterSpacing: -0.3,
            ),
          ),
          Text(
            AppConstants.feelingQuestion,
            style: TextStyle(
              fontSize: questionFontSize,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: sectionSpacing),
          const SessionBannerCard(),
          const SizedBox(height: 12),
          MoodCheckinCard(
            selectedMood: selectedMood,
            onMoodSelected: onMoodSelected,
          ),
          SizedBox(height: sectionSpacing),
          const ListenerSection(),
          const SizedBox(height: 14),
          const TalkRandomlyButton(),
          SizedBox(height: sectionSpacing),
          const FeatureBanner(),
          SizedBox(height: sectionSpacing + 4),
          const CareUnitsSection(),
          const SizedBox(height: 16),
          const CounsellingBanner(),
          SizedBox(height: sectionSpacing),
          const CorporateProgramsSection(),
          SizedBox(height: sectionSpacing),
        ],
      ),
    );
  }
}
