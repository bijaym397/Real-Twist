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

  static const String iosAppLinked = "https://flutter.dev/";
  static const String androidAppLinked = "https://flutter.dev/";

  //Game endpoints
  static const String spendCoin = "spincoin/spend";
  static const String spinCoinStatus = "spincoin/status/";

  //Payment endpoints
  static const String payment = "payment/create-checkout-session";
  static const String sellCoins = "payment/request";
  static const String updatePaymentStatus = "payment/status";
  static const String paymentHistory = "user/payment";
  static const String userCoinHistory = "user/coin-histroy";
  static const String adminPaymentHistory = "admin/payment-history";
  static const String spinCoinHistory = "admin/spincoin";

  //Network APi Endpoints
  static const String userNetwork = "network/";
  static const String userNetworkIncome = "network/income/";

  //Admin endpoints
  static const String getUserList = "admin/user-list?search=";
  static const String adminPaymentRequestWithdrawal =
      "admin/payment/request?paymentType=withdrawal";
  static const String adminPaymentRequestDeposit =
      "admin/payment/request?paymentType=deposit";
  static const String adminPaymentRequest = "admin/payment/request/";
  static const String getUserDetails = "admin/user/";
  static const String setCoinsPrice = "admin/set-config";
  static const String setVersion = "admin/set-config";
  static const String dashboardDetails = "admin/get-config?type=coinprice";

  static const String userType = "user";
  static const String adminType = "admin";

  static const String checkAppVersion = "admin/get-config?type=appversion";

  static const String appVersion = "1.0.8";

  static const String buyURl = "https://pmny.in/AIPlns6BskBN";
}
