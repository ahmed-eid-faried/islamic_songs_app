import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:islamic_songs/data/datasource/static/colors.dart';

class MyService extends GetxService {
  Future<MyService> init() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    handlingErrors();

    if (GetPlatform.isAndroid ||
        GetPlatform.isIOS ||
        GetPlatform.isMacOS ||
        GetPlatform.isWeb) {
      await Firebase.initializeApp(
          // options: DefaultFirebaseOptions.currentPlatform,
          );
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    // await locationMap.check(null);
    // await Firebase.initializeApp(
    //     options: DefaultFirebaseOptions.currentPlatform);
    // await requestPermissionsMessage();
    // await gettokens();
    // await intialmassage();
    // onMessageOpenedApp();
    // onBackgroundMessage();
    return this;
  }
}

initService() async {
  await Get.putAsync(() => MyService().init());
}

handlingErrors() {
  RenderErrorBox.backgroundColor = AppColor.primaryColor;
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();

  // ErrorWidget.builder = (FlutterErrorDetails details) {
  //   print("details of errors:- $details");
  //   return Container(
  //       color: AppColor.primaryColor,
  //       child: Padding(
  //         padding: const EdgeInsets.all(20),
  //         child: Text("$details"),
  //       ));
  // };
  // RenderErrorBox.textStyle = RenderErrorBox.textStyle;
  // RenderErrorBox.padding = const EdgeInsets.all(10);
}
