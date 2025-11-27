import 'package:apyar_app/app/core/models/apyar.dart';
import 'package:apyar_app/app/core/models/apyar_content.dart';
import 'package:apyar_app/app/core/models/bookmark.dart';
import 'package:apyar_app/more_libs/setting/core/path_util.dart';
import 'package:flutter/material.dart';
import 'package:t_db/t_db.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:apyar_app/app/my_app.dart';
import 'package:apyar_app/more_libs/desktop_exe/desktop_exe.dart';
import 'package:apyar_app/more_libs/setting/setting.dart';

void main() async {
  await ThanPkg.instance.init();

  await Setting.instance.init(
    appName: 'Apyar App',
    releaseUrl: 'https://github.com/ThanCoder/apyar_app/releases',
    onSettingSaved: (context, message) {
      showTSnackBar(context, message);
    },
  );

  await TWidgets.instance.init(
    defaultImageAssetsPath: 'assets/thancoder_logo.png',
    getDarkMode: () => Setting.getAppConfig.isDarkTheme,
  );

  if (TPlatform.isDesktop) {
    await DesktopExe.exportDesktopIcon(
      name: Setting.instance.appName,
      assetsIconPath: 'assets/thancoder_logo.png',
    );

    WindowOptions windowOptions = WindowOptions(
      size: Size(602, 568), // စတင်ဖွင့်တဲ့အချိန် window size

      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      center: false,
      title: Setting.instance.appName,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      // await windowManager.focus();
    });
  }
  // db
  final db = TDB.getInstance();
  await db.open(PathUtil.getDatabasePath(name: 'apyar.db'));
  db.setAdapter<Apyar>(ApyarAdapter());
  db.setAdapter<ApyarContent>(ApyarContentAdapter());
  db.setAdapter<Bookmark>(BookmarkAdapter());

  runApp(const MyApp());
}
