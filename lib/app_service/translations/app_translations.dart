import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../../utils/shared_preferences.dart';
import '../network/network_service.dart';

class AppTranslations extends Translations {
  static AppTranslations? _instance;

  static AppTranslations get instance {
    _instance ??= AppTranslations._init();
    return _instance!;
  }

  AppTranslations._init();

  Rx<Locale> locale = const Locale('en', 'US').obs;

  final enLocale = const Locale('en', 'US');
  final arLocale = const Locale('ar', 'SA');

  List<Locale> get supportedLocales => [enLocale, arLocale];

  void loadSavedLocale() {
    final savedCode = sp?.getString(SpUtil.languageCode) ?? 'en';
    if (savedCode == 'ar') {
      locale.value = arLocale;
    } else {
      locale.value = enLocale;
      if ((sp?.getString(SpUtil.languageCode) ?? '').isEmpty) {
        sp?.putString(SpUtil.languageCode, 'en');
      }
    }
  }

  void changeLocale(Locale locale) {
    this.locale.value = locale;
    Get.updateLocale(locale);
    sp?.putString(SpUtil.languageCode, locale.languageCode);
    NetworkService().refreshHeaders();
    if (locale.languageCode == 'ar') {
      Get.forceAppUpdate();
    }
  }

  @override
  Map<String, Map<String, String>> get keys => {
    "en_US": {
      // Auth
      "log_in": "Log in",
    },

    "ar_SA": {
      // Auth
      "log_in": "تسجيل الدخول",
    },
  };
}
