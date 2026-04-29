// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:benkelly864/core/common/widgets/common_button.dart';
import 'package:benkelly864/core/controllers/localization_controller.dart';
import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/core/utils/constants/colors.dart';
import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:benkelly864/core/utils/theme_globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late final LocalizationController _localizationController;
  late String _pendingLanguage;
  bool _isSaving = false;

  LocalizationController _resolveController() {
    if (Get.isRegistered<LocalizationController>()) {
      return Get.find<LocalizationController>();
    }
    return Get.put(LocalizationController(), permanent: true);
  }

  @override
  void initState() {
    super.initState();
    _localizationController = _resolveController();
    _pendingLanguage = _localizationController.selectedLanguageName;
  }

  Future<void> _saveSelection() async {
    if (_isSaving) return;
    final option = _localizationController.languages.firstWhere(
      (lang) => lang.name == _pendingLanguage,
      orElse: () => _localizationController.languages.first,
    );
    setState(() => _isSaving = true);
    await _localizationController.changeLanguage(option);
    if (!mounted) return;
    setState(() => _isSaving = false);
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text('${AppText.languageUpdated} (${option.nativeName})'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool darkTheme = isDark;
      final Color titleColor = darkTheme
          ? AppColors.accentGold
          : AppColors.textPrimary;
      final Color subtitleColor = darkTheme
          ? Colors.white70
          : Colors.grey.shade600;
      final languages = _localizationController.languages;
      final selectedLanguage = _pendingLanguage;
      return Container(
        decoration: BoxDecoration(
          image: darkTheme
              ? DecorationImage(
                  image: AssetImage(ImagePath.darkbackground),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Scaffold(
          backgroundColor: darkTheme ? Colors.transparent : Colors.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppText.languagesTitle,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: darkTheme
                                  ? Colors.black.withValues(alpha: 0.3)
                                  : Colors.grey.shade200,
                            ),
                            child: Icon(
                              Icons.close,
                              size: 20.w,
                              color: darkTheme
                                  ? AppColors.accentGold
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppText.languageSelectionTitle,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: titleColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            AppText.languageSelectionSubtitle,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Column(
                      children: List.generate(languages.length, (index) {
                        final lang = languages[index];
                        final bool isSelected = selectedLanguage == lang.name;
                        return Container(
                          margin: EdgeInsets.only(bottom: 12.h),
                          decoration: BoxDecoration(
                            color: darkTheme
                                ? Colors.black.withValues(alpha: 0.25)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accentGold
                                  : (darkTheme
                                        ? Colors.white24
                                        : Colors.grey.shade300),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            leading: Radio<String>(
                              value: lang.name,
                              groupValue: selectedLanguage,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() => _pendingLanguage = value);
                              },
                              activeColor: AppColors.accentGold,
                              fillColor: MaterialStateProperty.resolveWith(
                                (states) => AppColors.accentGold,
                              ),
                            ),
                            title: Text(
                              lang.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: darkTheme
                                    ? Colors.white
                                    : AppColors.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              lang.nativeName,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: subtitleColor,
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check,
                                    color: AppColors.accentGold,
                                    size: 24.w,
                                  )
                                : null,
                            onTap: () =>
                                setState(() => _pendingLanguage = lang.name),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      children: [
                        Expanded(
                          child: CommonButton(
                            onTap: () => Navigator.pop(context),
                            borderColor: AppColors.lightLimestoneTan,
                            backgroundColor: Colors.transparent,
                            textColor: AppColors.lightLimestoneTan,
                            text: AppText.cancel,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: CommonButton(
                            onTap: _saveSelection,
                            isLoading: _isSaving,
                            text: AppText.saveChanges,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
