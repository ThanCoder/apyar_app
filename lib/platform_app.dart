import 'package:apyar_app/ui/platforms/desktop/desktop_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class PlatformApp extends StatefulWidget {
  const new({super.key});

  @override
  State<PlatformApp> createState() => _PlatformAppState();
}

class _PlatformAppState extends State<PlatformApp> {
  @override
  Widget build(BuildContext context) {
    return TMaterialThemeProvider(
      getTheme: () => .dark,
      onChanged: (type) {},
      child: _body,
    );
  }

  Widget get _body {
    return DesktopHomeScreen(); 
  }
}
