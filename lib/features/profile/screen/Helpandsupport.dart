import 'package:benkelly864/core/common/widgets/custom_appbar.dart';
import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:benkelly864/features/profile/widgets/contact_card.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:get/get.dart';

class Helpandsupport extends StatelessWidget {
  const Helpandsupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool darkTheme = isDark;
      final Color titleColor = darkTheme
          ? AppColors.accentGold
          : const Color(0xFF172E1D);
      final Color subtitleColor = darkTheme
          ? Colors.white70
          : Colors.grey.shade600;

      return Container(
        decoration: BoxDecoration(
          image: darkTheme
              ? const DecorationImage(
                  image: AssetImage(ImagePath.darkbackground),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Scaffold(
          backgroundColor: darkTheme ? Colors.transparent : Colors.white,
          appBar: CustomAppBar(title: AppText.helpSupportTitle, showBack: true),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppText.helpQuickContact,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 16),
                ContactCard(
                  icon: LucideIcons.mail,
                  title: AppText.emailSupport,
                  subtitle: 'support@example.com',
                  subtitleColor: subtitleColor,
                  onTap: () {},
                ),
                ContactCard(
                  icon: LucideIcons.phone,
                  title: AppText.phoneSupport,
                  subtitle: '+1 (555) 123-4567',
                  subtitleColor: subtitleColor,
                  onTap: () {},
                ),
                ContactCard(
                  icon: LucideIcons.messageSquare,
                  title: AppText.liveChat,
                  subtitle: AppText.liveChatAvailability,
                  subtitleColor: subtitleColor,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppText.liveChatComingSoon)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
