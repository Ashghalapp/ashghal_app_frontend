import 'package:ashghal_app_frontend/config/app_theme.dart';
import 'package:ashghal_app_frontend/core/localization/local_controller.dart';
import 'package:ashghal_app_frontend/core_api/pusher_service.dart';
import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dependency_injection.dart';

class AppServices extends GetxService {
  late SharedPreferences prefs;
  late ThemeData apptheme;
  static late List<CameraDescription> cameras;
  static late PusherService pusher;

  // late SharedPreferences sharedPref;
  Future<AppServices> init() async {
    prefs = await SharedPreferences.getInstance();
    // Get.lazyPut(() => OnBoardingControllerImp());
    Get.lazyPut(() => AppLocallcontroller());
    cameras = await availableCameras();
    pusher = PusherService();
    await pusher.initialize();

    setupDependencies();
    apptheme = AppTheme.lightTheme;
    return this;
  }
}

initialServices() async {
  await Get.putAsync(() => AppServices().init());
}
