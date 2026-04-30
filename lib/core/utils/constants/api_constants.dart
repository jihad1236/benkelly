class ApiConstants {
  static const String baseUrl = 'http://63.34.15.207:8080';
  // static const String aiBaseUrl = 'https://benkelly864-ai.onrender.com/api/v1';

  static const String register = '$baseUrl/auth/register/register_user/';
  static const String verifyOtp = '$baseUrl/auth/register/verify-otp/';
  static const String login = '$baseUrl/auth/login/';
  static const String forgotPassword =
      '$baseUrl/auth/password/forgot/request-otp/';
  static const String forgotVerifyOtp =
      '$baseUrl/auth/password/forgot/verify-otp/';

  static const String discoverCollection = '$baseUrl/explore/collection/';
  static const String favouritesCollection = '$baseUrl/explore/favorite/';
  static const String savedToursCollection = '$baseUrl/tour/saved/all/';
  static const String recentFindsCollection = '$baseUrl/tour/all/';
  static String collectionDetails(int id) => '$baseUrl/explore/explore/$id/';

  static const String landmarkDetect =
      'http://63.34.15.207:8000/landmark/detect';
  static const String exploreCreate = '$baseUrl/explore/explore/';
  static const String resetPassword = '$baseUrl/auth/password/reset/';
  static const String googleSocialLogin = '$baseUrl/auth/google/';
  static const String privacy = '$baseUrl/auth/privacy/';
  static const String customerProfile = '$baseUrl/auth/customer/profile/';
  static const String settings = '$baseUrl/auth/settings/';
  static const String plans = '$baseUrl/payment/plans/';
  static const String createPayment = '$baseUrl/payment/create/';

  static const String nearbyPlaces = '$baseUrl/nearby-places/';

  //reward section implemented

  static const String rewardActivity = '$baseUrl/reward/activity/';
  static const String rewardCategoriesBuzzwords =
      '$baseUrl/reward/categories-buzzwords/';
  static const String rewardCollectionLooksUp =
      '$baseUrl/reward/collecition_looks_up/';
  static const String rewardBuzzwordBadge =
      '$baseUrl/reward/reward-buzzword-badge/';
  static const String rewardWalkingTourCompleted =
      '$baseUrl/reward/walking-tour-completed/';
}
