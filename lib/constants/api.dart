///Base URL
abstract class BaseUrl {
  static const String liveBaseUrl = "";
  static const String stageBaseUrl = "http://178.16.138.186:5000/api/";
}

abstract class Api {
  static const String baseUrl = BaseUrl.stageBaseUrl;

  // ///
  // static const String getBearer = "users/edit_profile";

  static const String login = "login";
  static const String signup = "signup";
  static const String forgotPassword = "forgot-password";
  static const String user = "user";
  static const String verifyOtp = "verify-otp";
  static const String verifyPasswordOtp = "verify-password-otp";
  static const String changePassword = "change-password";
  static const String homeDetails = "user/details";
  static const String referralCode = "by-referral-code";

  static const String socialData = "users/userSignupBySocial";
  static const String getStaticPages = "/get_page_content/";

  static const String getProfile = "users/get-profile/";
  static const String uploadProfileImage = "users/upload-image/";
  static const String editProfile = "users/edit-profile/";
  static const String profileChangePassword = "profile/change-password/";

  static const String uploadPrescription = "users/upload-prescription/";
  static const String getPrescription = "users/get-prescription/";
  static const String getAllPrescriptions = "users/list-prescription";
  static const String editPrescription = "users/edit-prescription";
  static const String deletePrescription = "users/delete_prescription";

  static const String setReminder = "users/set-reminder/";
  static const String getReminder = "users/get-reminder/";
  static const String editReminder = "users/edit-reminder/";

  static const String iosAppLinked = "https://flutter.dev/";
  static const String androidAppLinked = "https://flutter.dev/";

  //Game endpoints
  static const String spendCoin = "spincoin/spend";
  static const String spinCoinStatus = "spincoin/status/";

  //Payment endpoints
  static const String payment = "payment/create-checkout-session";
  static const String sellCoins = "payment/sell_coins";
  static const String updatePaymentStatus = "payment/status";
  static const String paymentHistory = "user/payment";
  static const String adminPaymentHistory = "admin/payment-history";
  static const String spinCoinHistory = "admin/spincoin";

  //Admin endpoints
  static const String getUserList = "admin/user-list";
  static const String getUserDetails = "admin/user/";
  static const String coinsPrice = "admin/coinsprice";
  static const String dashboardDetails = "admin/coinsprice?type=coinprice";

  static const String userType = "user";
  static const String adminType = "admin";
}
