import 'package:flutter/material.dart';
import 'package:thancoder_pre_app/app/ui/home/home_screen.dart';
import 'package:thancoder_pre_app/more_libs/setting/core/theme_switcher.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeSwitcher(
      builder: (config) => MaterialApp(
        debugShowCheckedModeBanner: false,
        // themeMode: config.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
        theme: config.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
        home: HomeScreen(),
      ),
    );
  }
}
