import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/responsive_util.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _shimmerController;
  late AnimationController _ringController;
  late AnimationController _exitController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _ring1Scale;
  late Animation<double> _ring1Opacity;
  late Animation<double> _ring2Scale;
  late Animation<double> _ring2Opacity;
  late Animation<double> _exitScale;
  late Animation<double> _exitOpacity;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _initAnimations();
    _startSequence();
  }

  void _initControllers() {
    _entryController = AnimationController(
      duration: const Duration(milliseconds: AppConstants.splashEntryDuration),
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: const Duration(
        milliseconds: AppConstants.splashShimmerDuration,
      ),
      vsync: this,
    );
    _ringController = AnimationController(
      duration: const Duration(milliseconds: AppConstants.splashRingDuration),
      vsync: this,
    );
    _exitController = AnimationController(
      duration: const Duration(milliseconds: AppConstants.splashExitDuration),
      vsync: this,
    );
  }

  void _initAnimations() {
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.08,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.08,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 30,
      ),
    ]).animate(_entryController);

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _ring1Scale = Tween<double>(begin: 1.0, end: 2.2).animate(
      CurvedAnimation(
        parent: _ringController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );
    _ring1Opacity = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _ringController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    );
    _ring2Scale = Tween<double>(begin: 1.0, end: 1.8).animate(
      CurvedAnimation(
        parent: _ringController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );
    _ring2Opacity = Tween<double>(begin: 0.35, end: 0.0).animate(
      CurvedAnimation(
        parent: _ringController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _exitScale = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));
    _exitOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));
  }

  Future<void> _startSequence() async {
    await _entryController.forward();
    _shimmerController.forward();
    _ringController.forward();
    await Future.delayed(const Duration(milliseconds: 1200));
    await _exitController.forward();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) =>
            FadeTransition(opacity: animation, child: const OnboardingScreen()),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _entryController.dispose();
    _shimmerController.dispose();
    _ringController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    final logoSize = isDesktop
        ? 240.0
        : (isTablet ? 200.0 : AppConstants.logoSize);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _entryController,
            _shimmerController,
            _ringController,
            _exitController,
          ]),
          builder: (context, child) {
            final entryOpacity = _opacityAnimation.value;
            final entryScale = _scaleAnimation.value;
            final exitScale =
                _exitController.isAnimating || _exitController.isCompleted
                ? _exitScale.value
                : 1.0;
            final exitOpacity =
                _exitController.isAnimating || _exitController.isCompleted
                ? _exitOpacity.value
                : 1.0;

            return Opacity(
              opacity: (entryOpacity * exitOpacity).clamp(0.0, 1.0),
              child: Transform.scale(
                scale: entryScale * exitScale,
                child: SizedBox(
                  width: logoSize * 2.5,
                  height: logoSize * 2.5,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _buildRippleRing(
                        _ring1Scale.value,
                        _ring1Opacity.value,
                        logoSize,
                      ),
                      _buildRippleRing(
                        _ring2Scale.value,
                        _ring2Opacity.value,
                        logoSize,
                      ),
                      _buildGlowBackdrop(logoSize),
                      _buildLogoWithShimmer(logoSize),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRippleRing(double scale, double opacity, double logoSize) {
    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primaryBlue, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildGlowBackdrop(double logoSize) {
    return Container(
      width: logoSize + 40,
      height: logoSize + 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withAlpha(25),
            blurRadius: 60,
            spreadRadius: 20,
          ),
          BoxShadow(
            color: AppColors.primaryBlue.withAlpha(15),
            blurRadius: 100,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoWithShimmer(double logoSize) {
    return ClipOval(
      child: Container(
        width: logoSize,
        height: logoSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.scaffoldBackground,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(logoSize * 0.175),
              child: Image.asset('assets/app logo.png', fit: BoxFit.contain),
            ),
            if (_shimmerController.isAnimating ||
                _shimmerController.isCompleted)
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(_shimmerAnimation.value * logoSize, 0),
                  child: Container(
                    width: logoSize * 0.4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withAlpha(0),
                          Colors.white.withAlpha(80),
                          Colors.white.withAlpha(0),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
