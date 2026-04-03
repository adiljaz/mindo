import 'package:flutter/material.dart';
import '../../../models/doctor_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../widgets/badges.dart';
import '../../../widgets/section_header.dart';

class CareUnitsSection extends StatelessWidget {
  const CareUnitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Care Units',
          subtitle: 'Specialized Care',
          onSeeAll: () {},
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: AppConstants.doctorCardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: DoctorData.doctors.length,
            padding: const EdgeInsets.only(right: 14),
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, i) => _DoctorCard(item: DoctorData.doctors[i]),
          ),
        ),
      ],
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final DoctorItem item;

  const _DoctorCard({required this.item});

  @override
  Widget build(BuildContext context) {
    const width = AppConstants.doctorCardWidth;

    return Container(
      width: width,
      padding: const EdgeInsets.fromLTRB(8, 11, 8, 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
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
          Positioned(
            top: -1,
            right: 0,
            child: Column(
              children: const [
                Icon(Icons.info_outline, size: 10, color: AppColors.primaryBlue),
                SizedBox(width: 2),
                Text(
                  "info",
                  style: TextStyle(
                    fontSize: 8,
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  const SizedBox(height: 28),
                  CircleAvatar(
                    radius: width * 0.26,
                    backgroundImage: NetworkImage(item.imageUrl),
                  ),
                  const Positioned(
                    bottom: 2,
                    right: 2,
                    child: OnlineBadge(size: 12),
                  ),
                ],
              ),
              const SizedBox(height: 6),
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
              Text(
                item.specialty,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
              ),
              Text(
                item.experience,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 13),
              Center(
                child: Container(
                  width: 95,
                  height: 25,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
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
