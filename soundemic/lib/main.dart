import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:soundemic/constant/colors.dart';
import 'package:google_fonts/google_fonts.dart';

import './constant/routes.dart';
import 'controller/auth_controller.dart';
import 'controller/homepage_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    Get.put(HomepageController());
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return GetMaterialApp(
      title: 'Soundemic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: GoogleFonts.nunito().fontFamily,
          // primarySwatch: Colors.blue,
          primaryColor: kbackground1),
      getPages: AppPages.routes,
      initialRoute: AppPages.INITIAL,
    );
  }
}
