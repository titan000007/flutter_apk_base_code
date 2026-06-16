class NetworkUrl {
  NetworkUrl._();
  // baseUrl
  static const String baseUrl = "https://productionapi.uberforboats.com";

  //Auth
  static const String login = '/v1/user/login';
  static const String register = '/v1/user/register-user';
  static const String forgotPassword = '/v1/user/auth/forgot-password';
  static const String deleteAccountUrl = '/v1/user/delete-account';
  static const String logoutUrl = '/v1/user/logout';
  static const String changePassword = '/v1/user/change-password';

  //User
  static const String getUserDetails = '/v1/user/getProfile';
  static const String updateUserDetails = '/v1/user/update-Profile';
  static const String uploadFile = '/v1/upload/upload-image';

  ///Orders
  static const String createOrder = '/v1/user/order/create-order';
  static const String createPaymentLink = '/v1/user/order/create-payment-link';

  static String fetchActiveOrders({required int page, required int limit}) =>
      '/v1/user/order/active-orders?page=$page&limit=$limit';

  static String fetchCompletedOrders({required int page, required int limit}) =>
      '/v1/user/order/completed-orders?page=$page&limit=$limit';

  static String fetchActiveOrderDetail({required String id}) =>
      '/v1/user/order/order-details?orderId=$id';

  static String fetchDriverLocation({required String id}) =>
      'v1/orders/$id/driver-location';

  static const String reportOrderIssue = '/v1/user/order/report-issue';
}
