import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviesai/views/splash_screen.dart';

void main() {
  runApp(MovieAIApp());
}

class ThemeController extends GetxController {
  var isDark = false.obs;

  ThemeData get theme => isDark.value ? ThemeData.dark() : ThemeData.light();

  void toggleTheme() => isDark.value = !isDark.value;
}

class MovieAIApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());

  MovieAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MovieAI',
        theme: themeController.theme,
        home: SplashScreen(), // will route to home after delay
      ),
    );
  }
}
