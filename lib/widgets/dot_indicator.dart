import 'package:flutter/material.dart';

class AnimatedDotIndicator extends StatelessWidget {
  final bool isActive;
  final double activeWidth;
  final double height;
  final Color activeColor;
  final Color inactiveColor;
  final Duration duration;

  const AnimatedDotIndicator({
    super.key,
    required this.isActive,
    this.activeWidth = 24,
    this.height = 8,
    required this.activeColor,
    required this.inactiveColor,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? activeWidth : height,
      height: height,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}

class DotIndicators extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;

  const DotIndicators({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return AnimatedDotIndicator(
          isActive: currentIndex == index,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
        );
      }),
    );
  }
}
