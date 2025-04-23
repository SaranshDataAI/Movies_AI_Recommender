import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moviesai/views/splash_screen.dart';
import 'package:moviesai/views/history_screen.dart';

void main() async {
  await GetStorage.init(); // ✅ initialize GetStorage for history
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
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => SplashScreen()),
          GetPage(name: '/history', page: () => HistoryScreen()),
        ],
      ),
    );
  }
}
