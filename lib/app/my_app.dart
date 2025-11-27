import 'package:apyar_app/app/ui/getstart/getstart_screen.dart';
import 'package:flutter/material.dart';
import 'package:apyar_app/app/ui/home/home_screen.dart';
import 'package:apyar_app/more_libs/setting/core/theme_switcher.dart';
import 'package:than_pkg/than_pkg.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final getstartReaded = TRecentDB.getInstance.getBool('getstart-readed');
    return ThemeSwitcher(
      builder: (config) => MaterialApp(
        debugShowCheckedModeBanner: false,
        // themeMode: config.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
        theme: config.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
        home: getstartReaded
            ? HomeScreen()
            : GetstartScreen(onSuccessChild: HomeScreen()),
      ),
    );
  }
}
