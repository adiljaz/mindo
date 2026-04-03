import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

enum FaceType { veryLow, low, neutral, good, great }

class MoodItem {
  final String label;
  final Color color;
  final FaceType faceType;

  const MoodItem({
    required this.label,
    required this.color,
    required this.faceType,
  });
}

class MoodData {
  static const List<MoodItem> moods = [
    MoodItem(
      label: 'Very Low',
      color: AppColors.moodVeryLow,
      faceType: FaceType.veryLow,
    ),
    MoodItem(
      label: 'Low',
      color: AppColors.moodLow,
      faceType: FaceType.low,
    ),
    MoodItem(
      label: 'Neutral',
      color: AppColors.moodNeutral,
      faceType: FaceType.neutral,
    ),
    MoodItem(
      label: 'Good',
      color: AppColors.moodGood,
      faceType: FaceType.good,
    ),
    MoodItem(
      label: 'Great',
      color: AppColors.moodGreat,
      faceType: FaceType.great,
    ),
  ];

  static const List<String> moodImages = [
    'assets/mood check in first item.jpeg',
    'assets/mood check in second item.jpeg',
    'assets/mood check in 3 rd item.jpeg',
    'assets/mood check in 4 th item.jpeg',
    'assets/mood check in 5 th item.jpeg',
  ];

  static String getMoodImage(int index) {
    return moodImages[index % moodImages.length];
  }
}
