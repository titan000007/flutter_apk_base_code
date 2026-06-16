import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uber_boats_customer/app/features/auth/login/view/get_started_screen.dart';
import 'package:uber_boats_customer/utils/app_string.dart';
import 'package:uber_boats_customer/utils/app_them.dart';
import 'package:uber_boats_customer/utils/app_utils.dart';
import 'package:uber_boats_customer/utils/shared_preferences.dart';
import 'app/features/dashboard/view/dashboard_screen.dart';
import 'app_service/network/network_service.dart';
import 'app_service/notification/notification_service.dart';
import 'app_service/stripe/stripe_config.dart';
import 'app_service/translations/app_translations.dart';
import 'firebase_options.dart';

SpUtil? sp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  sp = await SpUtil.getInstance();
  await NetworkService().initRepo();

  // Save FCM Token to Local Storage
  await AppUtils.saveFcmToken();

  // Update FCM Token to Server and Firestore if user is logged in
  if (AppUtils.checkUserLogin()) {
    AppUtils.updateFcmTokenApi();
  }

  await NotificationService().init();

  AppTranslations.instance.loadSavedLocale();

  SystemChannels.textInput.invokeMethod('TextInput.hide');

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await StripeConfig.initialize();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(const RunApp());
  });
}

class RunApp extends StatelessWidget {
  const RunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      title: AppString.appName.tr,
      home: AppUtils.checkUserLogin()
          ? const DashboardScreen()
          : const GetStartedScreen(),
    );
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Background message: ${message.messageId}');
}
