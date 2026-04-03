import 'package:flutter/material.dart';
import '../../../models/mood_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/responsive_util.dart';
import '../../../widgets/app_card.dart';

class MoodCheckinCard extends StatelessWidget {
  final int? selectedMood;
  final ValueChanged<int> onMoodSelected;

  const MoodCheckinCard({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    final cardHeight = isDesktop ? 160.0 : (isTablet ? 145.0 : 130.0);
    final titleFontSize = isDesktop ? 18.0 : (isTablet ? 16.0 : 15.0);
    final iconSize = isDesktop
        ? 56.0
        : (isTablet ? 50.0 : AppConstants.moodIconSize);
    final labelFontSize = isDesktop ? 13.0 : (isTablet ? 12.0 : 11.0);

    return AppCard(
      height: cardHeight,
      padding: EdgeInsets.only(
        top: isDesktop ? 24 : 20,
        left: isDesktop ? 24 : 20,
        right: isDesktop ? 24 : 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Mood Check-in',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(MoodData.moods.length, (i) {
              final mood = MoodData.moods[i];
              final isSelected = selectedMood == i;
              return _buildMoodItem(
                mood,
                i,
                isSelected,
                iconSize,
                labelFontSize,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodItem(
    MoodItem mood,
    int index,
    bool isSelected,
    double iconSize,
    double labelFontSize,
  ) {
    return GestureDetector(
      onTap: () => onMoodSelected(index),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: mood.color,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: AppColors.primaryBlue, width: 3)
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: mood.color.withAlpha((0.5 * 255).round()),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                MoodData.getMoodImage(index),
                width: iconSize * 0.9,
                height: iconSize * 0.9,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            mood.label,
            style: TextStyle(
              fontSize: labelFontSize,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primaryBlue : AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
