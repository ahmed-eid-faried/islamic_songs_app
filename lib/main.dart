import 'package:flutter/material.dart';
import 'package:islamic_songs/controller/controller.dart';
import 'package:islamic_songs/services.dart';
import 'package:islamic_songs/view/screen/home.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  initService();
  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        MyController controller = Get.put(MyController());
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: controller.kscaffoldMessengerKey,
          theme: ThemeData(
            textTheme: GoogleFonts.reemKufiTextTheme(),
          ),
          home: const Home(),
        );
      },
    );
  }
}
