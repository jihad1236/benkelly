import 'package:benkelly864/features/authentication/reset/screen/reset_password_screen.dart';
import 'package:benkelly864/features/camera/screens/image_analysing.dart';
import 'package:benkelly864/features/camera/screens/image_preview.dart';
import 'package:benkelly864/features/onboading/screens/camera_access.dart';
import 'package:benkelly864/features/onboading/screens/location_access.dart';
import 'package:benkelly864/features/onboading/screens/onboading_screen.dart';
import 'package:benkelly864/features/onboading/screens/onboading_views.dart';
import 'package:benkelly864/features/splash/screens/splash_screen.dart';
import 'package:benkelly864/features/navbar/screen/navbar_screen.dart';
import 'package:get/get.dart';
import '../features/authentication/fogot_password/screen/forgot_password_screen.dart';
import '../features/authentication/login/screen/login_screen.dart';
import '../features/authentication/signup/screen/signup_screen.dart';
import '../features/authentication/verify/screen/verify_screen.dart';
import '../features/building_details/screens/building_details_screen.dart';
import '../features/home/screen/home_screen.dart';
import '../features/generate_tour/screen/generate_tour_screen.dart';
import '../features/subscription/screen/subscription_screen.dart';
import '../features/tour/screen/tour_screen.dart';
import '../features/tour/screen/tour_map_screen.dart';

class AppRoute {
  static String homeScreen = "/homeScreen";
  static String splashScreen = "/splashScreen";
  static String navbar = "/navbarScreen";
  static String login = "/loginScreen";
  static String signup = "/signupScreen";
  static String verify = "/verifyScreen";
  static String forgotPassword = "/forgotPasswordScreen";
  static String resetPassword = "/resetPasswordScreen";

  static String onboadingScreen = "/onboadingScreen";
  static String cameraaccess = "/cameraaccess";
  static String locationaccess = "/locationaccess";
  static String onboardingviews = "/onboardingviews";

  static String imageanalysing = "/cameraanalysing";
  static String imagepreview = "/camerapreview";
  static String buildingDetailsScreen = "/buildingDetailsScreen";
  static String generateTourScreen = "/generateTourScreen";
  static String tourScreen = "/tourScreen";

  static String subscriptionScreen = "/subscriptionScreen";
  static String tourMapScreen = "/tourMapScreen";

  static String getHomeScreen() => homeScreen;
  static String getNavbarScreen() => navbar;
  static String getOnboadingScreen() => onboadingScreen;
  static String getcameraaccess() => cameraaccess;
  static String getlocationaccess() => locationaccess;
  static String getonboardingviews() => onboardingviews;
  static String getSplashScreen() => splashScreen;
  static String getLoginScreen() => login;
  static String getSignupScreen() => signup;
  static String getVerifyScreen() => verify;
  static String getForgotPasswordScreen() => forgotPassword;
  static String getResetPassword() => resetPassword;
  static String getCameraAnalysing() => imageanalysing;
  static String getCameraPreview() => imagepreview;
  static String getbuildingDetailsScreen() => buildingDetailsScreen;
  static String getGenerateTourScreen() => generateTourScreen;
  static String getSubscriptionScreen() => subscriptionScreen;
  static String getTourScreen() => tourScreen;


  static List<GetPage> routes = [
    GetPage(name: onboadingScreen, page: () => const OnboadingScreen()),
    GetPage(name: homeScreen, page: () => const HomeScreen()),
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: navbar, page: () => NavbarScreen()),
    GetPage(name: login, page: () => LoginScreen()),
    GetPage(name: signup, page: () => SignupScreen()),
    GetPage(name: verify, page: () => const VerifyScreen()),
    GetPage(name: forgotPassword, page: () => ForgotPasswordScreen()),
    GetPage(name: resetPassword, page: () => ResetPasswordScreen()),

    GetPage(name: cameraaccess, page: () => const CameraAccess()),
    GetPage(name: locationaccess, page: () => const LocationAccessScreen()),
    GetPage(name: onboardingviews, page: () => const OnboardingView()),

    GetPage(name: imageanalysing, page: () => const ImageAnalyzingScreen()),
    GetPage(name: imagepreview, page: () => const ImagePreview_screen()),
    GetPage(
      name: buildingDetailsScreen,
      page: () => const BuildingDetailsScreen(),
    ),
    GetPage(name: generateTourScreen, page: () => const GenerateTourScreen()),
    GetPage(name: subscriptionScreen, page: () => const SubscriptionScreen()),
    GetPage(name: tourScreen, page: () => const TourScreen()),
    GetPage(
      name: tourMapScreen,
      page: () {
        final stops = Get.arguments as List;
        return TourMapScreen(tourStops: stops.cast());
      },
    ),
  ];
}
