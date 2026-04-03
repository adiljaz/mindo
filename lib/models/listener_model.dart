import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ListenerItem {
  final String name;
  final String years;
  final String imageUrl;
  final Color color;

  const ListenerItem({
    required this.name,
    required this.years,
    required this.imageUrl,
    required this.color,
  });
}

class ListenerData {
  static const List<ListenerItem> listeners = [
    ListenerItem(
      name: 'Jonathan',
      years: '6+ Years',
      color: AppColors.moodVeryLow,
      imageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&q=80',
    ),
    ListenerItem(
      name: 'Sebastian',
      years: '4+ Years',
      color: AppColors.primaryBlue,
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&q=80',
    ),
    ListenerItem(
      name: 'Aliya',
      years: '4+ Years',
      color: AppColors.successGreen,
      imageUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&q=80',
    ),
    ListenerItem(
      name: 'Priya',
      years: '3+ Years',
      color: AppColors.moodLow,
      imageUrl:
          'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=300&q=80',
    ),
  ];
}
