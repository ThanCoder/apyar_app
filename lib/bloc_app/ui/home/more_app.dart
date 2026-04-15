import 'package:apyar_app/app/routes.dart';
import 'package:apyar_app/app/ui/database_manager/database_manager_screen.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:apyar_app/more_libs/setting/setting.dart';

class MoreApp extends StatelessWidget {
  const MoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('More App')),
      body: TScrollableColumn(
        children: [
          Setting.getThemeModeChooser,
          Setting.getSettingListTileWidget,
          Setting.getCurrentVersionWidget,
          Setting.getCacheManagerWidget,
          Divider(),
          Card(
            child: ListTile(
              title: Text('Database Manager'),
              onTap: () => goRoute(
                context,
                builder: (context) => DatabaseManagerScreen(),
              ),
            ),
          ),
          Setting.getThanCoderAboutWidget,
        ],
      ),
    );
  }
}
