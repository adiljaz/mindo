import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/onboarding_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/responsive_util.dart';
import '../widgets/dot_indicator.dart';
import '../widgets/primary_button.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _cardController;
  late AnimationController _textController;
  late AnimationController _floatController;

  late Animation<double> _cardScale;
  late Animation<double> _cardOpacity;
  late Animation<Offset> _cardSlide;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _descOpacity;
  late Animation<Offset> _descSlide;
  late Animation<double> _floatAnimation;

  final List<OnboardingData> _pages = const [
    OnboardingData(
      imageUrl:
          'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=600&q=80',
      title: 'Talk Anonymously',
      description:
          'Connect with compassionate listeners who are here for you. Share freely, without judgment.',
      icon: Icons.chat_bubble_outline,
    ),
    OnboardingData(
      imageUrl:
          'https://images.unsplash.com/photo-1544027993-37dbfe43562a?w=600&q=80',
      title: 'Expert Care & AI',
      description:
          'Professional counselors and Zuri AI — your personal mental health companion.',
      icon: Icons.favorite_outline,
    ),
    OnboardingData(
      imageUrl:
          'https://images.unsplash.com/photo-1499209974431-9dddcece7f88?w=600&q=80',
      title: 'Track Your Mood',
      description:
          'Log your emotions daily and discover patterns in your wellness journey.',
      icon: Icons.trending_up,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initControllers();
    _initAnimations();
    _playAnimations();
  }

  void _initControllers() {
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: AppConstants.onboardingCardDuration,
      ),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: AppConstants.onboardingTextDuration,
      ),
    );
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: AppConstants.onboardingFloatDuration,
      ),
    )..repeat(reverse: true);
  }

  void _initAnimations() {
    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );

    _cardScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutBack),
    );
    _cardOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _cardController, curve: Curves.easeOut));
    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _cardController, curve: Curves.easeOutCubic),
        );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    _descOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );
    _descSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _textController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );
  }

  Future<void> _playAnimations() async {
    _cardController.forward(from: 0);
    await Future.delayed(const Duration(milliseconds: 150));
    _textController.forward(from: 0);
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _cardController.reverse();
      _textController.reverse();
      Future.delayed(const Duration(milliseconds: 250), () {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      });
    } else {
      _navigateToHome();
    }
  }

  void _skip() {
    _navigateToHome();
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) =>
            FadeTransition(opacity: animation, child: const HomeScreen()),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _cardController.dispose();
    _textController.dispose();
    _floatController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                _buildSkipButton(isDesktop, isTablet),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      _playAnimations();
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) => _buildPageContent(
                      index,
                      constraints,
                      isDesktop,
                      isTablet,
                    ),
                  ),
                ),
                _buildBottomSection(constraints, isDesktop, isTablet),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkipButton(bool isDesktop, bool isTablet) {
    final fontSize = isDesktop ? 18.0 : (isTablet ? 16.0 : 14.0);

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: isDesktop ? 20 : 12,
          right: isDesktop ? 32 : 20,
        ),
        child: TextButton(
          onPressed: _skip,
          child: Text(
            'Skip',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(
    int index,
    BoxConstraints constraints,
    bool isDesktop,
    bool isTablet,
  ) {
    final page = _pages[index];
    final imageSize = isDesktop
        ? constraints.maxWidth * 0.45
        : (isTablet
              ? constraints.maxWidth * 0.55
              : constraints.maxWidth * 0.65);
    final titleFontSize = isDesktop ? 36.0 : (isTablet ? 32.0 : 28.0);
    final descFontSize = isDesktop ? 20.0 : (isTablet ? 18.0 : 16.0);
    final topSpacing = isDesktop ? 60.0 : (isTablet ? 50.0 : 40.0);
    final midSpacing = isDesktop ? 60.0 : (isTablet ? 50.0 : 50.0);

    return AnimatedBuilder(
      animation: Listenable.merge([
        _cardController,
        _textController,
        _floatController,
      ]),
      builder: (context, _) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 24),
            child: Column(
              children: [
                SizedBox(height: isDesktop ? 40 : topSpacing),
                _buildImageContainer(
                  page,
                  imageSize.clamp(200, isDesktop ? 500 : 320),
                ),
                SizedBox(height: midSpacing),
                _buildAnimatedText(
                  page.title,
                  _titleSlide,
                  _titleOpacity,
                  titleFontSize,
                  FontWeight.w700,
                  AppColors.darkBlue,
                ),
                const SizedBox(height: 12),
                _buildAnimatedText(
                  page.description,
                  _descSlide,
                  _descOpacity,
                  descFontSize,
                  FontWeight.w400,
                  Colors.grey[600]!,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageContainer(OnboardingData page, double imageSize) {
    return SlideTransition(
      position: _cardSlide,
      child: FadeTransition(
        opacity: _cardOpacity,
        child: ScaleTransition(
          scale: _cardScale,
          child: Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withAlpha(40),
                    blurRadius: 60,
                    spreadRadius: 10,
                    offset: const Offset(0, 20),
                  ),
                  BoxShadow(
                    color: AppColors.primaryBlue.withAlpha(20),
                    blurRadius: 100,
                    spreadRadius: 30,
                    offset: const Offset(0, 40),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 8),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: page.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: AppColors.lightBlue,
                    highlightColor: Colors.white,
                    child: Container(color: AppColors.lightBlue),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.lightBlue,
                    child: Icon(
                      page.icon,
                      color: AppColors.primaryBlue,
                      size: 60,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedText(
    String text,
    Animation<Offset> slide,
    Animation<double> opacity,
    double fontSize,
    FontWeight weight,
    Color color,
  ) {
    return SlideTransition(
      position: slide,
      child: FadeTransition(
        opacity: opacity,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: weight,
            color: color,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(
    BoxConstraints constraints,
    bool isDesktop,
    bool isTablet,
  ) {
    final horizontalPadding = isDesktop ? 48.0 : 24.0;
    final buttonHeight = isDesktop ? 64.0 : (isTablet ? 58.0 : 54.0);

    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        bottom: isDesktop ? 40 : 32,
        top: isDesktop ? 24 : 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DotIndicators(
            count: _pages.length,
            currentIndex: _currentPage,
            activeColor: AppColors.primaryBlue,
            inactiveColor: Colors.grey[300]!,
          ),
          SizedBox(height: isDesktop ? 32 : 28),
          PrimaryButton(
            text: _currentPage == _pages.length - 1
                ? 'Get Started'
                : 'Continue',
            onPressed: _nextPage,
            height: buttonHeight,
            icon: Icons.arrow_forward,
          ),
        ],
      ),
    );
  }
}
