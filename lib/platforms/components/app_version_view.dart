import 'package:apyar_app/core/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppVersionView extends StatefulWidget {
  const AppVersionView({super.key});

  @override
  State<AppVersionView> createState() => _AppVersionViewState();
}

class _AppVersionViewState extends State<AppVersionView> {
  ColorScheme get col => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: col.surfaceContainer,
      contentPadding: .symmetric(vertical: 10, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      leading: Container(
        padding: .all(8),
        decoration: BoxDecoration(
          color: col.surfaceContainerHigh,
          borderRadius: .circular(15),
        ),
        child: Icon(Icons.info_outline, color: col.onSurface),
      ),
      title: Text(
        'Version: ${AppUtil.instance.version}',
        style: TextStyle(color: col.onSurface),
      ),
      subtitle: Text('Check for updates and view release notes'),
      trailing: Icon(Icons.launch_outlined),
      onTap: () {
        launchUrlString('https://github.com/ThanCoder/apyar_app/releases');
      },
    );
  }
}
