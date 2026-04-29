import 'dart:async';

import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:benkelly864/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingPageModel {
  final String title;

  final String image;

  OnboardingPageModel({required this.title, required this.image});
}

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  Timer? _timer;

  final List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      title: AppText.captureAnyBuilding,
      image: 'assets/icons/build.png',
    ),
    OnboardingPageModel(
      title: AppText.aiAnalyzesBuilding,
      image: 'assets/icons/search.png',
    ),
    OnboardingPageModel(
      title: AppText.collectAndExplore,
      image: 'assets/icons/browser.png',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _startAutoScroll();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentPage.value < pages.length - 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        pageController.jumpToPage(0);
      }
    });
  }

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      finishOnboarding();
    }
  }

  void skip() {
    pageController.jumpToPage(pages.length - 1);
  }

  void onPageChanged(int index) => currentPage.value = index;

  void finishOnboarding() {
    _timer?.cancel();
    Get.offAllNamed(AppRoute.navbar);
  }
}
