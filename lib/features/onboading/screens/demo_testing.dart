// // ==================== MODEL ====================
// // File: lib/models/onboarding_page_model.dart

// import 'package:carousel_slider/carousel_controller.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// class OnboardingPageModel {
//   final String title;
//   final String subtitle;
//   final String image;

//   OnboardingPageModel({
//     required this.title,
//     required this.subtitle,
//     required this.image,
//   });
// }

// class OnboardingController extends GetxController {
//   final CarouselSliderController carouselController =
//       CarouselSliderController();
//   final RxInt currentPage = 0.obs;

//   final List<OnboardingPageModel> pages = [
//     OnboardingPageModel(
//       title: 'Discover Paradise',
//       subtitle: 'Explore breathtaking destinations around the world',
//       image:
//           'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
//     ),
//     OnboardingPageModel(
//       title: 'Adventure Awaits',
//       subtitle: 'Experience thrilling journeys and create memories',
//       image:
//           'https://images.unsplash.com/photo-1682687220742-aba13b6e50ba?w=800',
//     ),
//     OnboardingPageModel(
//       title: 'Plan Your Journey',
//       subtitle: 'Book your dream vacation with just a few taps',
//       image:
//           'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=800',
//     ),
//   ];

//   void nextPage() {
//     if (currentPage.value < pages.length - 1) {
//       carouselController.nextPage(
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       finishOnboarding();
//     }
//   }

//   void skip() {
//     carouselController.jumpToPage(pages.length - 1);
//   }

//   void onPageChanged(int index) => currentPage.value = index;

//   void finishOnboarding() {
//     Get.snackbar('Welcome!', 'Ready to start your journey');
//     // Get.toNamed(AppRoute.login);
//   }
// }

// // ==================== CAROUSEL WIDGET ====================
// // File: lib/widgets/travel_carousel_widget.dart

// // import 'package:your_app/controllers/onboarding_controller.dart';

// class TravelCarouselWidget extends StatelessWidget {
//   final OnboardingController controller;

//   const TravelCarouselWidget({Key? key, required this.controller})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return CarouselSlider.builder(
//       carouselController: controller.carouselController,
//       itemCount: controller.pages.length,
//       options: CarouselOptions(
//         height: double.infinity,
//         viewportFraction: 0.85,
//         enlargeCenterPage: true,
//         enlargeFactor: 0.3,
//         enableInfiniteScroll: false,
//         autoPlay: true,
//         autoPlayInterval: const Duration(seconds: 4),
//         autoPlayAnimationDuration: const Duration(milliseconds: 1200),
//         autoPlayCurve: Curves.easeInOutCubicEmphasized,
//         onPageChanged: (index, reason) {
//           controller.onPageChanged(index);
//         },
//       ),
//       itemBuilder: (context, index, realIndex) {
//         final page = controller.pages[index];
//         return Obx(() {
//           final isActive = controller.currentPage.value == index;

//           return AnimatedContainer(
//             duration: const Duration(milliseconds: 400),
//             margin: EdgeInsets.symmetric(vertical: isActive ? 0 : 30),
//             child: Column(
//               children: [
//                 // Image Card
//                 Expanded(
//                   flex: 3,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(30),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.3),
//                           blurRadius: 30,
//                           offset: const Offset(0, 15),
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(30),
//                       child: Stack(
//                         fit: StackFit.expand,
//                         children: [
//                           Image.network(
//                             page.image,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Container(
//                                 color: Colors.grey.shade300,
//                                 child: const Icon(
//                                   Icons.image,
//                                   size: 80,
//                                   color: Colors.grey,
//                                 ),
//                               );
//                             },
//                           ),
//                           // Gradient Overlay
//                           Container(
//                             decoration: BoxDecoration(
//                               gradient: LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   Colors.transparent,
//                                   Colors.black.withOpacity(0.7),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           // Text Content
//                           Positioned(
//                             bottom: 30,
//                             left: 25,
//                             right: 25,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   page.title,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 32,
//                                     fontWeight: FontWeight.bold,
//                                     height: 1.2,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Text(
//                                   page.subtitle,
//                                   style: TextStyle(
//                                     color: Colors.white.withOpacity(0.9),
//                                     fontSize: 16,
//                                     height: 1.4,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         });
//       },
//     );
//   }
// }

// // ==================== MAIN SCREEN ====================
// // File: lib/screens/onboarding_screen.dart

// // import 'package:your_app/controllers/onboarding_controller.dart';
// // import 'package:your_app/widgets/travel_carousel_widget.dart';

// class OnboardingScreen extends StatelessWidget {
//   final OnboardingController controller = Get.put(OnboardingController());

//   OnboardingScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Gradient Background
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Colors.blue.shade900, Colors.purple.shade900],
//               ),
//             ),
//           ),

//           // Main Content
//           SafeArea(
//             child: Column(
//               children: [
//                 // Skip Button
//                 Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       TextButton(
//                         onPressed: controller.skip,
//                         child: const Text(
//                           'Skip',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 // Carousel Slider Widget
//                 Expanded(child: TravelCarouselWidget(controller: controller)),

//                 const SizedBox(height: 30),

//                 // Dot Indicators
//                 Obx(
//                   () => Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(controller.pages.length, (index) {
//                       final isActive = controller.currentPage.value == index;
//                       return AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         margin: const EdgeInsets.symmetric(horizontal: 4),
//                         height: 8,
//                         width: isActive ? 32 : 8,
//                         decoration: BoxDecoration(
//                           color: isActive
//                               ? Colors.white
//                               : Colors.white.withOpacity(0.4),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                       );
//                     }),
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//                 // Next Button
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30),
//                   child: SizedBox(
//                     width: double.infinity,
//                     height: 60,
//                     child: ElevatedButton(
//                       onPressed: controller.nextPage,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: Colors.blue.shade900,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         elevation: 5,
//                       ),
//                       child: Obx(
//                         () => Text(
//                           controller.currentPage.value ==
//                                   controller.pages.length - 1
//                               ? 'Get Started'
//                               : 'Next',
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
