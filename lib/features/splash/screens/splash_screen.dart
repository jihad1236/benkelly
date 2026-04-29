import 'package:benkelly864/core/utils/constants/image_path.dart';
import 'package:benkelly864/features/onboading/screens/onboading_screen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'dart:async';
import 'package:benkelly864/core/services/storage_service.dart';
import 'package:benkelly864/features/profile/controllers/profile_controller.dart';
import 'package:benkelly864/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _logoController;
  late AnimationController _logoSlideController;

  late Animation<Offset> _slideTop;
  late Animation<Offset> _slideLeft;
  late Animation<Offset> _slideRight;
  late Animation<Offset> _slideBottom;

  late Animation<double> _fadeOut;
  late Animation<double> _logoScale;
  late Animation<Offset> _logoSlide;

  bool showLogo = false;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    final curve = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeInOutCubic,
    );

    _slideLeft = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.5, 0),
    ).animate(curve);

    _slideRight = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0),
    ).animate(curve);

    _slideTop = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1.5),
    ).animate(curve);

    _slideBottom = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1.5),
    ).animate(curve);

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(curve);

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _logoSlide = Tween<Offset>(begin: Offset.zero, end: const Offset(-1.2, 0))
        .animate(
          CurvedAnimation(
            parent: _logoSlideController,
            curve: Curves.easeInOut,
          ),
        );

    _startSequence();
  }

  Future<void> _startSequence() async {
    await _bgController.forward();
    if (mounted) {
      if (StorageService.hasToken()) {
        if (!Get.isRegistered<ProfileController>()) {
          Get.put(ProfileController(), permanent: true);
        }
        Get.offAllNamed(AppRoute.navbar);
      } else {
        Get.off(() => const OnboadingScreen());
      }
    }
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    _logoSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImagePath.darkbackground),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // // 3️⃣ TOP
            Align(
              alignment: Alignment.topCenter,
              child: FadeTransition(
                opacity: _fadeOut,
                child: SlideTransition(
                  position: _slideTop,
                  child: Align(
                    alignment: Alignment.topCenter,

                    child: Image.asset(
                      'assets/images/Intersect-3 1.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),

            // // 4️⃣ BOTTOM
            Align(
              alignment: Alignment.bottomCenter,
              child: FadeTransition(
                opacity: _fadeOut,
                child: SlideTransition(
                  position: _slideBottom,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/images/Intersect 1.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FadeTransition(
                opacity: _fadeOut,
                child: SlideTransition(
                  position: _slideRight,
                  child: Image.asset(
                    'assets/images/Intersect-1 1.png',
                    fit: BoxFit.fill,

                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: FadeTransition(
                opacity: _fadeOut,
                child: SlideTransition(
                  position: _slideLeft,
                  child: Image.asset(
                    'assets/images/Intersect-2 1.png',
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
