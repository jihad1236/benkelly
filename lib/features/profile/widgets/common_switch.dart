import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:flutter/material.dart';

class CommonSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CommonSwitch({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool darkTheme = isDark;
    final Color titleColor =
        darkTheme ? AppColors.accentGold : const Color(0xFF303030);
    final Color subtitleColor =
        darkTheme ? Colors.white70 : AppColors.kSubtitleColor;
    final Color activeTrack =
        darkTheme ? AppColors.deepForest : AppColors.kPrimaryAccent;
    final Color inactiveTrack =
        darkTheme ? Colors.white24 : const Color(0xFFCBCED4);
    final Color activeThumb =
        darkTheme ? AppColors.accentGold : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: subtitleColor,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: activeThumb,
            activeTrackColor: activeTrack,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: inactiveTrack,
          ),
        ],
      ),
    );
  }
}
