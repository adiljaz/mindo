import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../models/listener_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/responsive_util.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/badges.dart';

class ListenerSection extends StatelessWidget {
  const ListenerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    final listHeight = isDesktop ? 220.0 : (isTablet ? 200.0 : 176.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Talk to a Listener',
          subtitle: 'Non-Judgemental & Anonymous',
          onSeeAll: () {},
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: listHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: ListenerData.listeners.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) =>
                _ListenerCard(item: ListenerData.listeners[i]),
          ),
        ),
      ],
    );
  }
}

class _ListenerCard extends StatelessWidget {
  final ListenerItem item;

  const _ListenerCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    final cardWidth = isDesktop
        ? 140.0
        : (isTablet ? 128.0 : AppConstants.listenerCardWidth);
    final avatarSize = isDesktop
        ? 90.0
        : (isTablet ? 80.0 : AppConstants.avatarRadius * 2);
    final nameFontSize = isDesktop ? 14.0 : (isTablet ? 12.0 : 11.0);
    final yearsFontSize = isDesktop ? 11.0 : (isTablet ? 10.0 : 9.0);

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.09),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 12 : 8,
          vertical: isDesktop ? 16 : 13,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    width: avatarSize,
                    height: avatarSize,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: AppColors.shimmerBase,
                      highlightColor: AppColors.shimmerHighlight,
                      child: Container(
                        width: avatarSize,
                        height: avatarSize,
                        color: AppColors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: avatarSize / 2,
                      backgroundColor: item.color.withAlpha(40),
                      child: Text(
                        item.name[0],
                        style: TextStyle(
                          color: item.color,
                          fontWeight: FontWeight.w800,
                          fontSize: isDesktop ? 32 : 28,
                        ),
                      ),
                    ),
                  ),
                ),
                const Positioned(bottom: -13, child: PhoneBadge()),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              item.name,
              style: TextStyle(
                fontSize: nameFontSize,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A2E),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              item.years,
              style: TextStyle(
                fontSize: yearsFontSize,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 152, 152, 152),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const OnlineBadge(size: 8),
                const SizedBox(width: 5),
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: yearsFontSize,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 0, 0, 0),
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
