import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/app_card.dart';

class CorporateProgramsSection extends StatelessWidget {
  const CorporateProgramsSection({super.key});

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
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        _buildSAPCard(),
        const SizedBox(height: 14),
        _buildEAPCard(),
      ],
    );
  }

  Widget _buildSAPCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.sapDarkBlue,
        borderRadius: BorderRadius.circular(7),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const Text(
                'Early support to identify, guide and connect\nstudents facing emotional, behavioral, or\nmental health challenges.',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.sapLightText,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
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
                    Icon(Icons.arrow_forward, size: 15, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: -10,
            bottom: -1,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.asset('assets/coffe layer.png', fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEAPCard() {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.eapGreenBg,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(
                  Icons.psychology_outlined,
                  color: Color(0xFF3A3A3A),
                  size: 40,
                ),
              ),
              const SizedBox(width: 8),
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
          Center(
            child: SizedBox(
              width: 170,
              height: 35,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.eapButton,
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
    );
  }
}
