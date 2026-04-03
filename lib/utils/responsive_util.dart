import 'package:flutter/material.dart';

class ScreenUtil {
  static late double screenWidth;
  static late double screenHeight;
  static late double textScaleFactor;
  static late bool isTablet;
  static late bool isDesktop;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
    textScaleFactor = mediaQuery.textScaleFactor;

    isTablet = screenWidth >= 600 && screenWidth < 1200;
    isDesktop = screenWidth >= 1200;
  }

  // Responsive width based on percentage of screen
  static double wp(double percentage) => (screenWidth * percentage) / 100;

  // Responsive height based on percentage of screen
  static double hp(double percentage) => (screenHeight * percentage) / 100;

  // Responsive font size
  static double sp(double size) => size * textScaleFactor;

  // Get adaptive value based on screen size
  static T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  // Scale size based on shortest side
  static double scale(double size) {
    final shortestSide = screenWidth < screenHeight
        ? screenWidth
        : screenHeight;
    final referenceSize = 375.0; // iPhone X reference
    return size * (shortestSide / referenceSize);
  }

  // Padding responsiveness
  static double get defaultPadding =>
      responsive(mobile: 16.0, tablet: 24.0, desktop: 32.0);
  static double get smallPadding =>
      responsive(mobile: 8.0, tablet: 12.0, desktop: 16.0);

  // Aspect ratio helpers
  static double get cardAspectRatio => screenWidth / (screenWidth * 0.6);
  static double get bannerAspectRatio => 16 / 9;
}

// Extension for easy responsive access
extension ResponsiveBuildContext on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;
  bool get isMobile => screenWidth < 600;
  double get textScale => MediaQuery.of(this).textScaleFactor;

  double wp(double percentage) => (screenWidth * percentage) / 100;
  double hp(double percentage) => (screenHeight * percentage) / 100;
  double sp(double size) => size * textScale;
}
