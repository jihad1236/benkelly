import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? subtitleColor;
  final VoidCallback onTap;

  const ContactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final bool darkTheme = isDark;
        final Color cardColor =
            darkTheme ? Colors.black.withValues(alpha: 0.25) : Colors.white;
        final Color borderColor =
            darkTheme ? AppColors.accentGold : AppColors.lightLimestoneTan;
        final Color iconBackground = darkTheme
            ? Colors.black.withValues(alpha: 0.35)
            : Colors.grey.shade200;
        final Color iconColor =
            darkTheme ? AppColors.accentGold : AppColors.kPrimaryAccent;
        final Color titleColor =
            darkTheme ? AppColors.accentGold : const Color(0xFF303030);
        final Color effectiveSubtitleColor =
            subtitleColor ?? (darkTheme ? Colors.white70 : AppColors.kSubtitleColor);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: titleColor,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: effectiveSubtitleColor,
              ),
            ),
            onTap: onTap,
          ),
        );
      },
    );
  }
}
