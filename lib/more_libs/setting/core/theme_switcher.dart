import 'dart:async';

import 'package:flutter/material.dart';
import 'package:t_widgets/theme/t_theme_services.dart';

import '../app_config.dart';
import '../setting.dart';

class ThemeSwitcher extends StatefulWidget {
  final Widget Function(AppConfig config) builder;
  const ThemeSwitcher({super.key, required this.builder});

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  late StreamSubscription<TThemeModes> _themeSub;

  @override
  void initState() {
    _themeSub = TThemeServices.instance.onBrightnessChanged.listen((data) {
      final oldConfig = Setting.getAppConfigNotifier.value;
      if (oldConfig.themeMode == TThemeModes.system &&
          oldConfig.isDarkTheme != data.isDarkMode) {
        final newConfig = Setting.getAppConfigNotifier.value.copyWith(
          isDarkTheme: data.isDarkMode,
        );
        Setting.getAppConfigNotifier.value = newConfig;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _themeSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Setting.getAppConfigNotifier,
      builder: (context, config, child) {
        return widget.builder(config);
      },
    );
  }
}
