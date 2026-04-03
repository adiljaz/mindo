import 'dart:async';

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

// ─── ENTRY POINT ─────────────────────────────────────────────────────────────
void main() {
  runApp(const MindoApp());
}

class MindoApp extends StatelessWidget {
  const MindoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF2F4F7),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D6A9F)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// ─── SPLASH SCREEN ────────────────────────────────────────────────────────────

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
  late Animation<double> _blurAnimation;
  late Animation<double> _ring1Scale;
  late Animation<double> _ring1Opacity;
  late Animation<double> _ring2Scale;
  late Animation<double> _ring2Opacity;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _exitScale;
  late Animation<double> _exitOpacity;

  @override
  void initState() {
    super.initState();

    // Entry animation: 0.8s
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Shimmer glow sweep
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Ripple rings
    _ringController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Exit animation
    _exitController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // --- Entry ---
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

    _blurAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    // --- Shimmer sweep ---
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // --- Ripple rings ---
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

    // --- Exit ---
    _exitScale = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));
    _exitOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));

    _startSequence();
  }

  Future<void> _startSequence() async {
    // 1. Entry pop-in (800ms)
    await _entryController.forward();

    // 2. Shimmer + rings together (1200ms + 1000ms)
    _shimmerController.forward();
    _ringController.forward();

    // Wait for shimmer and rings to complete
    await Future.delayed(const Duration(milliseconds: 1200));

    // 3. Exit animation (500ms) - smooth transition
    await _exitController.forward();

    // Navigate after exit animation completes
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
    const logoSize = 160.0;
    const primaryColor = Color(0xFF2D6A9F);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
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
                      // Ripple ring 1
                      Transform.scale(
                        scale: _ring1Scale.value,
                        child: Opacity(
                          opacity: _ring1Opacity.value,
                          child: Container(
                            width: logoSize,
                            height: logoSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryColor, width: 2),
                            ),
                          ),
                        ),
                      ),

                      // Ripple ring 2
                      Transform.scale(
                        scale: _ring2Scale.value,
                        child: Opacity(
                          opacity: _ring2Opacity.value,
                          child: Container(
                            width: logoSize,
                            height: logoSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryColor,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Glow backdrop
                      Container(
                        width: logoSize + 40,
                        height: logoSize + 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withAlpha(25),
                              blurRadius: 60,
                              spreadRadius: 20,
                            ),
                            BoxShadow(
                              color: primaryColor.withAlpha(15),
                              blurRadius: 100,
                              spreadRadius: 40,
                            ),
                          ],
                        ),
                      ),

                      // Logo circle with shimmer
                      ClipOval(
                        child: Container(
                          width: logoSize,
                          height: logoSize,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFF2F4F7),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(28),
                                child: Image.asset(
                                  'assets/app logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              // Shimmer sweep overlay
                              if (_shimmerController.isAnimating ||
                                  _shimmerController.isCompleted)
                                Positioned.fill(
                                  child: Transform.translate(
                                    offset: Offset(
                                      _shimmerAnimation.value * logoSize,
                                      0,
                                    ),
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
                      ),
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
}

// ─── ONBOARDING SCREEN ──────────────────────────────────────────────────────────
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

  static const Color primaryBlue = Color(0xFF2D6A9F);
  static const Color lightBlue = Color(0xFFE8F4FC);
  static const Color darkBlue = Color(0xFF1A4A73);

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      imageUrl:
          'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=600&q=80',
      title: 'Talk Anonymously',
      description:
          'Connect with compassionate listeners who are here for you. Share freely, without judgment.',
      icon: Icons.chat_bubble_outline,
    ),
    _OnboardingData(
      imageUrl:
          'https://images.unsplash.com/photo-1544027993-37dbfe43562a?w=600&q=80',
      title: 'Expert Care & AI',
      description:
          'Professional counselors and Zuri AI — your personal mental health companion.',
      icon: Icons.favorite_outline,
    ),
    _OnboardingData(
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
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );

    _setupAnimations();
    _playAnimations();
  }

  void _setupAnimations() {
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
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, animation, __) =>
              FadeTransition(opacity: animation, child: const HomeScreen()),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  void _skip() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) =>
            FadeTransition(opacity: animation, child: const HomeScreen()),
        transitionDuration: const Duration(milliseconds: 400),
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, right: 20),
                    child: TextButton(
                      onPressed: _skip,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: primaryBlue,
                        ),
                      ),
                    ),
                  ),
                ),

                // Page content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      _playAnimations();
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) =>
                        _buildPageContent(index, constraints),
                  ),
                ),

                // Bottom section
                _buildBottomSection(constraints),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPageContent(int index, BoxConstraints constraints) {
    final page = _pages[index];
    final imageSize = constraints.maxWidth * 0.65;
    final isSmallScreen = constraints.maxHeight < 700;

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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(height: isSmallScreen ? 20 : 40),

                // Image container with white highlight
                SlideTransition(
                  position: _cardSlide,
                  child: FadeTransition(
                    opacity: _cardOpacity,
                    child: ScaleTransition(
                      scale: _cardScale,
                      child: Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: Container(
                          width: imageSize.clamp(200, 320),
                          height: imageSize.clamp(200, 320),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: primaryBlue.withAlpha(40),
                                blurRadius: 60,
                                spreadRadius: 10,
                                offset: const Offset(0, 20),
                              ),
                              BoxShadow(
                                color: primaryBlue.withAlpha(20),
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
                                baseColor: lightBlue,
                                highlightColor: Colors.white,
                                child: Container(color: lightBlue),
                              ),
                              errorWidget: (_, __, ___) => Container(
                                color: lightBlue,
                                child: Icon(
                                  page.icon,
                                  color: primaryBlue,
                                  size: 60,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: isSmallScreen ? 30 : 50),

                // Title
                SlideTransition(
                  position: _titleSlide,
                  child: FadeTransition(
                    opacity: _titleOpacity,
                    child: Text(
                      page.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: darkBlue,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Description
                SlideTransition(
                  position: _descSlide,
                  child: FadeTransition(
                    opacity: _descOpacity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        page.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSection(BoxConstraints constraints) {
    final isSmallScreen = constraints.maxHeight < 700;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: isSmallScreen ? 20 : 32,
        top: isSmallScreen ? 16 : 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dot indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) {
              final isActive = _currentPage == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? primaryBlue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),

          SizedBox(height: isSmallScreen ? 20 : 28),

          // CTA Button
          SizedBox(
            width: double.infinity,
            height: isSmallScreen ? 50 : 54,
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Continue',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data model ──────────────────────────────────────────────────────────────
class _OnboardingData {
  final String imageUrl;
  final String title;
  final String description;
  final IconData icon;

  const _OnboardingData({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.icon,
  });
}

// ─── HOME SCREEN ─────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int? _selectedMood;

  final GlobalKey<CurvedNavigationBarState> _navKey = GlobalKey();

  final List<_MoodItem> _moods = const [
    _MoodItem(
      label: 'Very Low',
      color: Color(0xFFD46EC8),
      faceType: FaceType.veryLow,
    ),
    _MoodItem(label: 'Low', color: Color(0xFFE88B6E), faceType: FaceType.low),
    _MoodItem(
      label: 'Neutral',
      color: Color(0xFFE8A830),
      faceType: FaceType.neutral,
    ),
    _MoodItem(label: 'Good', color: Color(0xFF82CC8A), faceType: FaceType.good),
    _MoodItem(
      label: 'Great',
      color: Color(0xFFA8D44A),
      faceType: FaceType.great,
    ),
  ];

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _HomeBody(
          moods: _moods,
          selectedMood: _selectedMood,
          onMoodSelected: (i) => setState(() => _selectedMood = i),
        );
      case 1:
        return const _StubPage(title: 'Journal');
      case 2:
        return const _StubPage(title: 'Ask Zuri');
      case 3:
        return const _StubPage(title: 'Experts');
      case 4:
        return const _StubPage(title: 'Community');
      default:
        return const _StubPage(title: 'Home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      extendBody: true,
      body: SafeArea(bottom: false, child: _buildPage(_selectedIndex)),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CurvedNavigationBar(
            key: _navKey,
            index: _selectedIndex,
            height: 55,
            color: Colors.white,
            backgroundColor: Colors.transparent,
            buttonBackgroundColor: const Color(0xFF2D6A9F),
            animationDuration: const Duration(milliseconds: 300),
            animationCurve: Curves.easeInOut,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: [
              _navIconOnly(Icons.home_rounded, _selectedIndex == 0),
              _navIconOnly(Icons.view_column_rounded, _selectedIndex == 1),
              SizedBox(
                width: 44,
                height: 44,
                child: Image.asset('assets/zuri.png', fit: BoxFit.contain),
              ),
              _navIconOnly(
                Icons.medical_services_outlined,
                _selectedIndex == 3,
              ),
              _navIconOnly(Icons.people_alt_outlined, _selectedIndex == 4),
            ],
          ),
          _staticNavLabels(),
        ],
      ),
    );
  }

  Widget _navIconOnly(IconData icon, bool isSelected) {
    return Icon(
      icon,
      size: 24,
      color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
    );
  }

  Widget _staticNavLabels() {
    final labels = ['Home', 'Journal', 'Ask Zuri', 'Experts', 'Community'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 8),
      child: Transform.translate(
        offset: const Offset(0, -4),
        child: Row(
          children: List.generate(5, (index) {
            final isSelected = _selectedIndex == index;
            return Expanded(
              child: Center(
                child: Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? const Color(0xFF2D6A9F)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─── STUB PAGE ────────────────────────────────────────────────────────────────
class _StubPage extends StatelessWidget {
  final String title;
  const _StubPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2D6A9F),
        ),
      ),
    );
  }
}

// ─── HOME BODY ────────────────────────────────────────────────────────────────
class _HomeBody extends StatelessWidget {
  final List<_MoodItem> moods;
  final int? selectedMood;
  final ValueChanged<int> onMoodSelected;

  const _HomeBody({
    required this.moods,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TopBar(),
          const SizedBox(height: 10),
          const Text(
            'Good Morning,Steve',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.3,
            ),
          ),

          const Text(
            'How are you feeling today?',
            style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 20),
          const SessionBannerCard(),
          const SizedBox(height: 20),
          _MoodCheckinCard(
            moods: moods,
            selectedMood: selectedMood,
            onMoodSelected: onMoodSelected,
          ),
          const SizedBox(height: 20),
          const _ListenerSection(),
          const SizedBox(height: 14),
          const _TalkRandomlyButton(),

          const SizedBox(height: 20),
          const _FeatureBannerImage(),

          const SizedBox(height: 24),
          const _CareUnitsSection(),
          const SizedBox(height: 16),
          const _CounsellingBannerCard(),
          const SizedBox(height: 20),
          const _CorporateProgramsSection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─── TOP BAR ─────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 10),
          child: Transform.scale(
            scale: 3.5,
            child: Image.asset(
              'assets/app logo.png',
              width: 44,
              height: 44,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Row(
          children: [
            _NavIconButton(
              icon: Icons.phone,
              iconColor: Colors.red,
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _NavIconButton(
              icon: Icons.notifications,
              iconColor: const Color(0xFF2D6A9F),
              badge: true,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _NavIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final bool badge;
  final VoidCallback onTap;

  const _NavIconButton({
    required this.icon,
    required this.iconColor,
    this.badge = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: iconColor, size: 22),
            if (badge)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── SESSION BANNER CARD ─────────────────────────────────────────────────────
// Also available as standalone in session_banner_widget.dart
class SessionBannerCard extends StatelessWidget {
  const SessionBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 25),
          child: Stack(
            children: [
              // Text content on left
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'No Sessions Scheduled Today',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A2E),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'Talk to a Listener and Feel Better',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Start Session button
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D6A9F),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'Start Session',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // View Plans link
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: const [
                        Text(
                          'View Plans',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          size: 14,
                          color: Color(0xFF1A1A2E),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Image positioned on right bottom, extending outside card
              Positioned(
                right: -130,
                left: 30,
                top: 28,
                child: Image.asset(
                  'assets/bannerlogonew.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SessionIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 130,
      child: CustomPaint(painter: _IllustrationPainter()),
    );
  }
}

class _IllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final blobPath = Path()
      ..moveTo(w * 0.1, h * 0.5)
      ..quadraticBezierTo(w * 0.0, h * 0.1, w * 0.5, h * 0.05)
      ..quadraticBezierTo(w * 1.0, h * 0.0, w * 0.95, h * 0.5)
      ..quadraticBezierTo(w * 1.0, h * 0.95, w * 0.5, h * 1.0)
      ..quadraticBezierTo(w * 0.0, h * 1.05, w * 0.1, h * 0.5)
      ..close();
    canvas.drawPath(blobPath, Paint()..color = const Color(0xFFD6E8F7));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.2, h * 0.1, w * 0.6, h * 0.45),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF5B4FCF),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.24, h * 0.14, w * 0.52, h * 0.37),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFEEEEFF),
    );

    final barPaint = Paint()..color = const Color(0xFF7C6FF7);
    for (int i = 0; i < 4; i++) {
      final barH = [0.12, 0.20, 0.15, 0.25][i] * h;
      canvas.drawRect(
        Rect.fromLTWH(
          w * 0.28 + i * w * 0.10,
          h * 0.14 + (h * 0.37 - barH) - h * 0.04,
          w * 0.07,
          barH,
        ),
        barPaint,
      );
    }

    canvas.drawRect(
      Rect.fromLTWH(w * 0.46, h * 0.55, w * 0.08, h * 0.08),
      Paint()..color = const Color(0xFF5B4FCF),
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.35, h * 0.63, w * 0.30, h * 0.04),
      Paint()..color = const Color(0xFF5B4FCF),
    );

    canvas.drawCircle(
      Offset(w * 0.18, h * 0.62),
      w * 0.065,
      Paint()..color = const Color(0xFFFFB347),
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.11, h * 0.68, w * 0.14, h * 0.18),
      Paint()..color = const Color(0xFF7C6FF7),
    );

    canvas.drawCircle(
      Offset(w * 0.82, h * 0.62),
      w * 0.065,
      Paint()..color = const Color(0xFFFFB347),
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.75, h * 0.68, w * 0.14, h * 0.15),
      Paint()..color = const Color(0xFFFF7043),
    );

    canvas.drawOval(
      Rect.fromLTWH(w * 0.0, h * 0.55, w * 0.14, h * 0.25),
      Paint()..color = const Color(0xFF66BB6A),
    );
    canvas.drawOval(
      Rect.fromLTWH(w * 0.86, h * 0.60, w * 0.14, h * 0.22),
      Paint()..color = const Color(0xFF66BB6A),
    );
    canvas.drawCircle(
      Offset(w * 0.82, h * 0.88),
      w * 0.06,
      Paint()..color = const Color(0xFFFF7043),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── MOOD CHECK-IN ────────────────────────────────────────────────────────────
enum FaceType { veryLow, low, neutral, good, great }

class _MoodItem {
  final String label;
  final Color color;
  final FaceType faceType;
  const _MoodItem({
    required this.label,
    required this.color,
    required this.faceType,
  });
}

class _MoodCheckinCard extends StatelessWidget {
  final List<_MoodItem> moods;
  final int? selectedMood;
  final ValueChanged<int> onMoodSelected;

  const _MoodCheckinCard({
    required this.moods,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Mood Check-in',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(moods.length, (i) {
              final mood = moods[i];
              final isSelected = selectedMood == i;
              return GestureDetector(
                onTap: () => onMoodSelected(i),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: mood.color,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(
                                color: const Color(0xFF2D6A9F),
                                width: 3,
                              )
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: mood.color.withAlpha(
                                    (0.5 * 255).round(),
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          _getMoodImage(i),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      mood.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF2D6A9F)
                            : const Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _getMoodImage(int index) {
    final images = [
      'assets/mood check in first item.jpeg',
      'assets/mood check in second item.jpeg',
      'assets/mood check in 3 rd item.jpeg',
      'assets/mood check in 4 th item.jpeg',
      'assets/mood check in 5 th item.jpeg',
    ];
    return images[index % images.length];
  }
}

class _FacePainter extends CustomPainter {
  final FaceType faceType;
  const _FacePainter(this.faceType);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.drawCircle(
      Offset(w * 0.35, h * 0.38),
      w * 0.075,
      Paint()..color = const Color(0xFF1A1A2E),
    );
    canvas.drawCircle(
      Offset(w * 0.65, h * 0.38),
      w * 0.075,
      Paint()..color = const Color(0xFF1A1A2E),
    );

    final mouthPaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final mouthPath = Path();
    switch (faceType) {
      case FaceType.veryLow:
      case FaceType.low:
        mouthPath.moveTo(w * 0.28, h * 0.70);
        mouthPath.quadraticBezierTo(w * 0.50, h * 0.56, w * 0.72, h * 0.70);
        break;
      case FaceType.neutral:
        mouthPath.moveTo(w * 0.28, h * 0.66);
        mouthPath.lineTo(w * 0.72, h * 0.66);
        break;
      case FaceType.good:
      case FaceType.great:
        mouthPath.moveTo(w * 0.28, h * 0.58);
        mouthPath.quadraticBezierTo(w * 0.50, h * 0.78, w * 0.72, h * 0.58);
        break;
    }
    canvas.drawPath(mouthPath, mouthPaint);
  }

  @override
  bool shouldRepaint(covariant _FacePainter oldDelegate) =>
      oldDelegate.faceType != faceType;
}

// ─── LISTENER SECTION ─────────────────────────────────────────────────────────
class _ListenerSection extends StatelessWidget {
  const _ListenerSection();

  static const List<_ListenerItem> _listeners = [
    _ListenerItem(
      name: 'Jonathan',
      years: '6+ Years',
      color: Color(0xFFD46EC8),
      imageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&q=80',
    ),
    _ListenerItem(
      name: 'Sebastian',
      years: '4+ Years',
      color: Color(0xFF2D6A9F),
      imageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&q=80',
    ),
    _ListenerItem(
      name: 'Aliya',
      years: '4+ Years',
      color: Color(0xFF66BB6A),
      imageUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&q=80',
    ),
    _ListenerItem(
      name: 'Priya',
      years: '3+ Years',
      color: Color(0xFFE88B6E),
      imageUrl:
          'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=300&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Talk to a Listener',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: const [
                  Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF2D6A9F),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 15, color: Color(0xFF2D6A9F)),
                ],
              ),
            ),
          ],
        ),

        const Text(
          'Non-Judgemental & Anonymous',
          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 16),
        // Horizontal scroll list
        SizedBox(
          height: 176,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: _listeners.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) => _ListenerCard(item: _listeners[i]),
          ),
        ),
      ],
    );
  }
}

// ─── UPDATED LISTENER DATA ────────────────────────────────────────────────────
class _ListenerItem {
  final String name;
  final String years;
  final String imageUrl;
  final Color color;
  const _ListenerItem({
    required this.name,
    required this.years,
    required this.imageUrl,
    required this.color,
  });
}

class _ListenerCard extends StatelessWidget {
  final _ListenerItem item;
  const _ListenerCard({required this.item});

  @override
  Widget build(BuildContext context) {
    const double avatarRadius = 35.0; // 88px diameter

    return Container(
      width: 112,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.09),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Photo + phone badge stacked
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                // Circular avatar
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    width: avatarRadius * 2,
                    height: avatarRadius * 2,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: const Color(0xFFE0E0E0),
                      highlightColor: const Color(0xFFF5F5F5),
                      child: Container(
                        width: avatarRadius * 2,
                        height: avatarRadius * 2,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: item.color.withAlpha(40),
                      child: Text(
                        item.name[0],
                        style: TextStyle(
                          color: item.color,
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                // Green phone badge — centered, overlapping bottom of avatar
                Positioned(
                  bottom: -13,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3DD68C),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3DD68C).withAlpha(100),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.phone,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            // Space to clear the overlapping badge
            const SizedBox(height: 18),

            // Name
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),

            // Years
            Text(
              item.years,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 152, 152, 152),
              ),
            ),

            // Online indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3DD68C),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── TALK RANDOMLY BUTTON ─────────────────────────────────────────────────────
class _TalkRandomlyButton extends StatelessWidget {
  const _TalkRandomlyButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Center(
        child: Container(
          height: 45,

          width: 170,
          padding: const EdgeInsets.symmetric(vertical: 7), // 🔥 reduced height
          decoration: BoxDecoration(
            color: const Color(0xFF4A76A8), // 🔥 closer to image color
            borderRadius: BorderRadius.circular(4), // 🔥 less rounded
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15), // 🔥 softer shadow
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.phone, color: Colors.white, size: 20),
              SizedBox(width: 8), // 🔥 tighter spacing
              Text(
                'Talk Randomly',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600, // 🔥 medium bold
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── FEATURE BANNER IMAGE ─────────────────────────────────────────────────────
class _FeatureBannerImage extends StatelessWidget {
  const _FeatureBannerImage();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=800&q=80',
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: const Color(0xFFE0E0E0),
              highlightColor: const Color(0xFFF5F5F5),
              child: Container(
                width: double.infinity,
                height: 190,
                color: Colors.white,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: double.infinity,
              height: 160,
              color: const Color(0xFFD6E8F7),
              child: const Icon(
                Icons.image_not_supported,
                size: 48,
                color: Colors.grey,
              ),
            ),
          ),
          // Dark overlay
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.black.withAlpha(100), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          // Play button
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(220),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(60),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: Color(0xFF2D6A9F),
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── CARE UNITS SECTION ───────────────────────────────────────────────────────
class _CareUnitsSection extends StatelessWidget {
  const _CareUnitsSection();

  static const List<_DoctorItem> _doctors = [
    _DoctorItem(
      name: 'Dr. Jonathan',
      specialty: 'Mental Health',
      experience: '10+ Years',
      imageUrl:
          'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=200&q=80',
    ),
    _DoctorItem(
      name: 'Dr. Aliya',
      specialty: 'Mental Health',
      experience: '8+ Years',
      imageUrl:
          'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=200&q=80',
    ),
    _DoctorItem(
      name: 'Dr. Sebastian',
      specialty: 'Psychiatry',
      experience: '12+ Years',
      imageUrl:
          'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=200&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Care Units',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1A1A2E),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: const [
                  Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF2D6A9F),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 15, color: Color(0xFF2D6A9F)),
                ],
              ),
            ),
          ],
        ),

        const Text(
          'Specialized Care',
          style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 194,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _doctors.length,
            padding: const EdgeInsets.only(right: 14),
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, i) => SizedBox(
              height: 80,
              width: 138,
              child: _DoctorCard(item: _doctors[i]),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── DOCTOR ITEM MODEL ────────────────────────────────────────────────────────
class _DoctorItem {
  final String name;
  final String specialty;
  final String experience;
  final String imageUrl;

  const _DoctorItem({
    required this.name,
    required this.specialty,
    required this.experience,
    required this.imageUrl,
  });
}

class _DoctorCard extends StatelessWidget {
  final _DoctorItem item;
  final double width;

  const _DoctorCard({required this.item, this.width = 138});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.fromLTRB(8, 11, 8, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          /// 🔵 INFO (TOP RIGHT - NO EXTRA SPACE)
          Positioned(
            top: -1,
            right: 0,
            child: Column(
              children: [
                Icon(Icons.info_outline, size: 10, color: Color(0xFF2D6A9F)),
                const SizedBox(width: 2),
                Text(
                  "info",
                  style: TextStyle(
                    fontSize: 8,
                    color: Color(0xFF2D6A9F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          /// 🟢 MAIN CONTENT
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 🔥 AVATAR (MOVED UP)
              Stack(
                children: [
                  SizedBox(height: 28),

                  CircleAvatar(
                    radius: width * 0.26,
                    backgroundImage: NetworkImage(item.imageUrl),
                  ),

                  /// Online dot
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              /// 👨‍⚕️ NAME
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              /// 🧠 SPECIALTY
              Text(
                item.specialty,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 9, color: Color(0xFF6B7280)),
              ),

              /// ⭐ EXPERIENCE
              Text(
                item.experience,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF2D6A9F),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 13),

              /// 🔘 BUTTON
              Center(
                child: Container(
                  width: 95,
                  height: 25,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D6A9F),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Book Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── COUNSELLING BANNER CARD ──────────────────────────────────────────────────
class _CounsellingBannerCard extends StatelessWidget {
  const _CounsellingBannerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEAEEF4),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(19, 19, 14, 19),
      child: Stack(
        children: [
          // ── Right: illustration positioned lower ───────────────────────
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

          // ── Left: text + button ──────────────────────────────────────────
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
                  color: Color(0xFF6B7280),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B6FA0),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B6FA0).withAlpha(80),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Schedule Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── COUNSELLING ILLUSTRATION PAINTER ────────────────────────────────────────
class _CounsellingIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Monitor / Screen ───────────────────────────────────────────────────
    final screenPaint = Paint()..color = const Color(0xFF3B6FA0);
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.28, h * 0.04, w * 0.68, h * 0.50),
      const Radius.circular(5),
    );
    canvas.drawRRect(screenRect, screenPaint);

    // Screen inner white area
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.31, h * 0.08, w * 0.62, h * 0.41),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFEFF4FB),
    );

    // Bar chart bars on screen
    final barColors = [
      const Color(0xFF3B6FA0),
      const Color(0xFF3B6FA0),
      const Color(0xFF3B6FA0),
      const Color(0xFFFF8C42),
    ];
    final barHeights = [0.12, 0.19, 0.14, 0.22];
    for (int i = 0; i < 4; i++) {
      final bh = barHeights[i] * h;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            w * 0.35 + i * w * 0.13,
            h * 0.08 + (h * 0.41 - bh) - h * 0.04,
            w * 0.09,
            bh,
          ),
          const Radius.circular(2),
        ),
        Paint()..color = barColors[i],
      );
    }

    // Monitor stand
    canvas.drawRect(
      Rect.fromLTWH(w * 0.56, h * 0.54, w * 0.08, h * 0.07),
      Paint()..color = const Color(0xFF3B6FA0),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.46, h * 0.60, w * 0.28, h * 0.04),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF3B6FA0),
    );

    // ── Standing Person (right - presenter) ──────────────────────────────
    // Head
    canvas.drawCircle(
      Offset(w * 0.88, h * 0.17),
      w * 0.09,
      Paint()..color = const Color(0xFFFFB347),
    );
    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.78, h * 0.28, w * 0.20, h * 0.32),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF5B9BD5),
    );
    // Left arm (pointing to screen)
    final armPath = Path()
      ..moveTo(w * 0.78, h * 0.34)
      ..quadraticBezierTo(w * 0.58, h * 0.30, w * 0.62, h * 0.28);
    canvas.drawPath(
      armPath,
      Paint()
        ..color = const Color(0xFF5B9BD5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.07
        ..strokeCap = StrokeCap.round,
    );
    // Legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.79, h * 0.59, w * 0.08, h * 0.24),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF2D4A7A),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.89, h * 0.59, w * 0.08, h * 0.24),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF2D4A7A),
    );

    // ── Seated Person (left - client) ────────────────────────────────────
    // Head
    canvas.drawCircle(
      Offset(w * 0.14, h * 0.25),
      w * 0.09,
      Paint()..color = const Color(0xFFFFB347),
    );
    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.04, h * 0.36, w * 0.20, h * 0.26),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF3B6FA0),
    );
    // Lap / seated legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.02, h * 0.58, w * 0.24, h * 0.07),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF2D4A7A),
    );

    // ── Chair ─────────────────────────────────────────────────────────────
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.00, h * 0.64, w * 0.28, h * 0.04),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF8BA8C8),
    );
    // Chair back
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * -0.02, h * 0.36, w * 0.04, h * 0.28),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF8BA8C8),
    );
    // Chair legs
    for (double x in [w * 0.02, w * 0.22]) {
      canvas.drawRect(
        Rect.fromLTWH(x, h * 0.68, w * 0.04, h * 0.18),
        Paint()..color = const Color(0xFF8BA8C8),
      );
    }

    // ── Notification badge on monitor (top right) ─────────────────────────
    canvas.drawCircle(
      Offset(w * 0.93, h * 0.06),
      w * 0.07,
      Paint()..color = const Color(0xFF3B6FA0),
    );
    canvas.drawCircle(
      Offset(w * 0.93, h * 0.06),
      w * 0.04,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── CORPORATE & PARTNERSHIP PROGRAMS SECTION ─────────────────────────────────
class _CorporateProgramsSection extends StatelessWidget {
  const _CorporateProgramsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Corporate & Partnership Programs',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 14),

        // ── SAP Card (dark blue) ──────────────────────────────────────────
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1E4D7B),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.10),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
          child: Stack(
            children: [
              // Content column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row with lock icon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Text(
                          'SAP(Student Assistance Program)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.lock_outline_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Multi-line description
                  const Text(
                    'Early support to identify, guide and connect\nstudents facing emotional, behavioral, or\nmental health challenges.',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFBDD5EE),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Unlock Now link
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: const [
                        Text(
                          'Unlock Now',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward,
                          size: 15,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Image positioned at bottom right corner
              // ADJUST POSITION: Change these values to move the image
              // left: X  - distance from left (use instead of right)
              // right: X - distance from right edge
              // top: X   - distance from top
              // bottom: X - distance from bottom edge
              Positioned(
                right: -10, // <-- ADJUST: distance from right edge
                bottom: -1, // <-- ADJUST: distance from bottom edge
                // Removed top constraint so image can grow freely
                child: SizedBox(
                  width: 100, // <-- ADJUST: image width
                  height: 100, // <-- ADJUST: image height
                  child: Image.asset(
                    'assets/coffe layer.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // ── EAP Card (white) ──────────────────────────────────────────────
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: icon + title + description
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Green icon box
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6F0D6),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(
                      Icons.psychology_outlined,
                      color: Color(0xFF3A3A3A),
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Title + description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'EAP',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              TextSpan(
                                text: '(Employee Assistance Program)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Confidential support to help employees manage\nmental health, stress, and work-related\nchallenges.',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF555555),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Start Journey button - centered
              Center(
                child: SizedBox(
                  width: 170,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A72A8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Start Journey',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── EAP INFO CHIP ────────────────────────────────────────────────────────────
class _EAPInfoChip extends StatelessWidget {
  final String label;
  final String value;

  const _EAPInfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF9E9E9E)),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── SAP ILLUSTRATION PAINTER ─────────────────────────────────────────────────
class _SapIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Body (dress - brown/maroon)
    final bodyPath = Path()
      ..moveTo(w * 0.25, h * 0.52)
      ..lineTo(w * 0.15, h * 1.00)
      ..lineTo(w * 0.85, h * 1.00)
      ..lineTo(w * 0.75, h * 0.52)
      ..close();
    canvas.drawPath(bodyPath, Paint()..color = const Color(0xFF7D4E2D));

    // Shirt/top (lighter brown)
    final shirtPath = Path()
      ..moveTo(w * 0.28, h * 0.48)
      ..lineTo(w * 0.20, h * 0.70)
      ..lineTo(w * 0.80, h * 0.70)
      ..lineTo(w * 0.72, h * 0.48)
      ..close();
    canvas.drawPath(shirtPath, Paint()..color = const Color(0xFFA0653A));

    // Neck
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.43, h * 0.30, w * 0.14, h * 0.10),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFFFCC99),
    );

    // Head
    canvas.drawOval(
      Rect.fromLTWH(w * 0.28, h * 0.04, w * 0.44, h * 0.30),
      Paint()..color = const Color(0xFFFFCC99),
    );

    // Hair (dark brown, covering top of head)
    final hairPath = Path()
      ..moveTo(w * 0.28, h * 0.16)
      ..quadraticBezierTo(w * 0.30, h * 0.02, w * 0.50, h * 0.02)
      ..quadraticBezierTo(w * 0.70, h * 0.02, w * 0.72, h * 0.16)
      ..quadraticBezierTo(w * 0.68, h * 0.08, w * 0.50, h * 0.07)
      ..quadraticBezierTo(w * 0.32, h * 0.08, w * 0.28, h * 0.16)
      ..close();
    canvas.drawPath(hairPath, Paint()..color = const Color(0xFF3E2000));

    // Hair sides / ponytail hint
    canvas.drawOval(
      Rect.fromLTWH(w * 0.24, h * 0.10, w * 0.10, h * 0.18),
      Paint()..color = const Color(0xFF3E2000),
    );
    canvas.drawOval(
      Rect.fromLTWH(w * 0.66, h * 0.10, w * 0.10, h * 0.18),
      Paint()..color = const Color(0xFF3E2000),
    );

    // Book (green, held in front)
    final bookPath = Path()
      ..moveTo(w * 0.30, h * 0.50)
      ..lineTo(w * 0.50, h * 0.44)
      ..lineTo(w * 0.70, h * 0.50)
      ..lineTo(w * 0.70, h * 0.72)
      ..lineTo(w * 0.50, h * 0.66)
      ..lineTo(w * 0.30, h * 0.72)
      ..close();
    canvas.drawPath(bookPath, Paint()..color = const Color(0xFF4CAF50));

    // Book spine line
    canvas.drawLine(
      Offset(w * 0.50, h * 0.44),
      Offset(w * 0.50, h * 0.66),
      Paint()
        ..color = const Color(0xFF2E7D32)
        ..strokeWidth = 1.5,
    );

    // Book highlight lines
    for (double yFrac in [0.52, 0.57, 0.62]) {
      canvas.drawLine(
        Offset(w * 0.34, h * yFrac),
        Offset(w * 0.48, h * (yFrac - 0.02)),
        Paint()
          ..color = Colors.white.withAlpha(120)
          ..strokeWidth = 1.2,
      );
    }

    // Left arm holding book
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.12, h * 0.52, w * 0.20, h * 0.10),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFFFFCC99),
    );

    // Right arm
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.68, h * 0.52, w * 0.20, h * 0.10),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFFFFCC99),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── DOCTOR ILLUSTRATION PAINTER ─────────────────────────────────────────────
class _DoctorIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Background blob (teal/dark blue semicircle) ───────────────────────
    final blobPaint = Paint()..color = const Color(0xFF1A6B72);
    final blobPath = Path()
      ..moveTo(w * 0.0, h * 0.55)
      ..quadraticBezierTo(w * 0.0, h * 1.05, w * 0.50, h * 1.05)
      ..quadraticBezierTo(w * 1.0, h * 1.05, w * 1.0, h * 0.55)
      ..quadraticBezierTo(w * 1.0, h * 0.30, w * 0.50, h * 0.32)
      ..quadraticBezierTo(w * 0.0, h * 0.30, w * 0.0, h * 0.55)
      ..close();
    canvas.drawPath(blobPath, blobPaint);

    // ── Scrubs body (teal green) ──────────────────────────────────────────
    final scrubsPath = Path()
      ..moveTo(w * 0.20, h * 0.60)
      ..lineTo(w * 0.15, h * 1.00)
      ..lineTo(w * 0.85, h * 1.00)
      ..lineTo(w * 0.80, h * 0.60)
      ..quadraticBezierTo(w * 0.65, h * 0.52, w * 0.50, h * 0.52)
      ..quadraticBezierTo(w * 0.35, h * 0.52, w * 0.20, h * 0.60)
      ..close();
    canvas.drawPath(scrubsPath, Paint()..color = const Color(0xFF2E9E7A));

    // Scrubs V-neck detail
    final vNeckPath = Path()
      ..moveTo(w * 0.40, h * 0.52)
      ..lineTo(w * 0.50, h * 0.65)
      ..lineTo(w * 0.60, h * 0.52);
    canvas.drawPath(
      vNeckPath,
      Paint()
        ..color = const Color(0xFF1A7A5E)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // ── Arms crossed ──────────────────────────────────────────────────────
    // Left arm
    final leftArm = Path()
      ..moveTo(w * 0.18, h * 0.65)
      ..quadraticBezierTo(w * 0.20, h * 0.80, w * 0.55, h * 0.82);
    canvas.drawPath(
      leftArm,
      Paint()
        ..color = const Color(0xFF2E9E7A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.13
        ..strokeCap = StrokeCap.round,
    );
    // Right arm
    final rightArm = Path()
      ..moveTo(w * 0.82, h * 0.65)
      ..quadraticBezierTo(w * 0.80, h * 0.80, w * 0.45, h * 0.82);
    canvas.drawPath(
      rightArm,
      Paint()
        ..color = const Color(0xFF2E9E7A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.13
        ..strokeCap = StrokeCap.round,
    );

    // Glove hands (light blue-green)
    canvas.drawOval(
      Rect.fromLTWH(w * 0.44, h * 0.78, w * 0.22, h * 0.12),
      Paint()..color = const Color(0xFF80CBC4),
    );

    // ── Neck ──────────────────────────────────────────────────────────────
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.42, h * 0.34, w * 0.16, h * 0.10),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFFFCC99),
    );

    // ── Face ──────────────────────────────────────────────────────────────
    // Head shape
    canvas.drawOval(
      Rect.fromLTWH(w * 0.28, h * 0.06, w * 0.44, h * 0.34),
      Paint()..color = const Color(0xFFFFCC99),
    );

    // Surgical cap (teal green)
    final capPath = Path()
      ..moveTo(w * 0.26, h * 0.20)
      ..quadraticBezierTo(w * 0.28, h * 0.02, w * 0.50, h * 0.01)
      ..quadraticBezierTo(w * 0.72, h * 0.02, w * 0.74, h * 0.20)
      ..quadraticBezierTo(w * 0.60, h * 0.16, w * 0.50, h * 0.16)
      ..quadraticBezierTo(w * 0.40, h * 0.16, w * 0.26, h * 0.20)
      ..close();
    canvas.drawPath(capPath, Paint()..color = const Color(0xFF2E9E7A));

    // Cap band
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.26, h * 0.17, w * 0.48, h * 0.05),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF1A7A5E),
    );

    // Mask (light teal)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.29, h * 0.24, w * 0.42, h * 0.16),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF80CBC4),
    );

    // Mask lines
    for (double yFrac in [0.28, 0.32, 0.36]) {
      canvas.drawLine(
        Offset(w * 0.32, h * yFrac),
        Offset(w * 0.68, h * yFrac),
        Paint()
          ..color = const Color(0xFF4DB6AC)
          ..strokeWidth = 1.0,
      );
    }

    // Eyes above mask
    canvas.drawOval(
      Rect.fromLTWH(w * 0.34, h * 0.17, w * 0.10, h * 0.06),
      Paint()..color = const Color(0xFF1A1A2E),
    );
    canvas.drawOval(
      Rect.fromLTWH(w * 0.56, h * 0.17, w * 0.10, h * 0.06),
      Paint()..color = const Color(0xFF1A1A2E),
    );

    // Eyebrows
    final browPaint = Paint()
      ..color = const Color(0xFF1A1A2E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.33, h * 0.155),
      Offset(w * 0.45, h * 0.150),
      browPaint,
    );
    canvas.drawLine(
      Offset(w * 0.55, h * 0.150),
      Offset(w * 0.67, h * 0.155),
      browPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
