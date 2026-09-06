import 'dart:async';

import 'package:apyar_app/core/utils/app_utils.dart';
import 'package:apyar_app/keys.dart';
import 'package:apyar_app/ui/pages/more/more_page.dart';
import 'package:apyar_app/ui/platforms/desktop/desktop_home_page.dart';
import 'package:flutter/material.dart';

class DesktopHomeScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<DesktopHomeScreen> createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {
  int index = 0;
  BoxConstraints? constraints;
  Timer? _saveTimer;

  void saveSize() {
    if (constraints == null) return;
    AppUtils.instance.config
        .put(appWidthkey, constraints!.maxWidth)
        .put(appHeightkey, constraints!.maxHeight)
        .writeAll();
    debugPrint('[_DesktopHomeScreenState:saveSize]: Saved Size');
  }

  void saveDelay() {
    _saveTimer?.cancel();
    _saveTimer = Timer(Duration(seconds: 3), () {
      saveSize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        this.constraints = constraints;
        saveDelay();
        return Row(
          children: [
            _navbar(),
            VerticalDivider(),
            Expanded(
              child: IndexedStack(
                index: index,
                children: [DesktopHomePage(), MorePage()],
              ),
            ),
          ],
        );
      },
    );
  }

  NavigationRail _navbar() => NavigationRail(
    onDestinationSelected: (value) {
      setState(() {
        index = value;
      });
    },
    selectedIndex: index,
    destinations: [
      .new(icon: Icon(Icons.home), label: Text('Home')),
      .new(icon: Icon(Icons.grid_view_outlined), label: Text('More')),
    ],
  );
}
