import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../utils/responsive_util.dart';
import 'home/home_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int? _selectedMood;

  final GlobalKey<CurvedNavigationBarState> _navKey = GlobalKey();

  final List<String> _labels = [
    'Home',
    'Journal',
    'Ask Zuri',
    'Experts',
    'Community',
  ];

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return HomeBody(
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
    ScreenUtil.init(context);
    final isTablet = context.isTablet;
    final isDesktop = context.isDesktop;

    final navHeight = isDesktop
        ? 70.0
        : (isTablet ? 65.0 : AppConstants.navHeight);
    final zuriSize = isDesktop ? 60.0 : (isTablet ? 52.0 : 44.0);
    final iconSize = isDesktop ? 28.0 : (isTablet ? 26.0 : 24.0);
    final labelFontSize = isDesktop ? 12.0 : (isTablet ? 11.0 : 10.0);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      extendBody: true,
      body: SafeArea(bottom: false, child: _buildPage(_selectedIndex)),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CurvedNavigationBar(
            key: _navKey,
            index: _selectedIndex,
            height: navHeight,
            color: Colors.white,
            backgroundColor: Colors.transparent,
            buttonBackgroundColor: AppColors.primaryBlue,
            animationDuration: const Duration(
              milliseconds: AppConstants.navAnimationDuration,
            ),
            animationCurve: Curves.easeInOut,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: [
              _navIconOnly(Icons.home_rounded, _selectedIndex == 0, iconSize),
              _navIconOnly(
                Icons.view_column_rounded,
                _selectedIndex == 1,
                iconSize,
              ),
              SizedBox(
                width: zuriSize,
                height: zuriSize,
                child: Image.asset('assets/zuri.png', fit: BoxFit.contain),
              ),
              _navIconOnly(
                Icons.medical_services_outlined,
                _selectedIndex == 3,
                iconSize,
              ),
              _navIconOnly(
                Icons.people_alt_outlined,
                _selectedIndex == 4,
                iconSize,
              ),
            ],
          ),
          _buildNavLabels(labelFontSize),
        ],
      ),
    );
  }

  Widget _navIconOnly(IconData icon, bool isSelected, double size) {
    return Icon(
      icon,
      size: size,
      color: isSelected ? Colors.white : AppColors.navGrey,
    );
  }

  Widget _buildNavLabels(double fontSize) {
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
                  _labels[index],
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primaryBlue
                        : AppColors.navGrey,
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

class _StubPage extends StatelessWidget {
  final String title;
  const _StubPage({required this.title});

  @override
  Widget build(BuildContext context) {
    final fontSize = context.isDesktop
        ? 32.0
        : (context.isTablet ? 28.0 : 24.0);
    return Center(
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryBlue,
        ),
      ),
    );
  }
}
