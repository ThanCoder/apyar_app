import 'package:apyar_app/bloc_app/cubits/apyar_bookmark_list_cubit.dart';
import 'package:apyar_app/bloc_app/cubits/apyar_list_cubit.dart';
import 'package:apyar_app/bloc_app/cubits/fetch_item_response_cubit.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/models/apyar_content.dart';
import 'package:apyar_app/core/models/bookmark.dart';
import 'package:apyar_app/core/providers/apyar_provider.dart';
import 'package:apyar_app/core/providers/bookmark_provider.dart';
import 'package:apyar_app/more_libs/setting/core/path_util.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:t_client/t_client.dart';
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
  final client = TClient();

  await TWidgets.instance.init(
    defaultImageAssetsPath: 'assets/apyar_log_3.jpg',
    isDarkTheme: () => Setting.getAppConfig.isDarkTheme,
    onDownloadImage: (url, savePath) async {
      await client.download(url, savePath: savePath);
    },
    getCachePath: (url) => PathUtil.getCachePath(
      name: StringPathExtensions(url.getCleanBackSlash).getName(),
    ),
  );

  if (TPlatform.isDesktop) {
    await DesktopExe.exportDesktopIcon(
      name: Setting.instance.appName,
      assetsIconPath: 'assets/apyar_log_3.jpg',
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
  // recent db
  await TRecentDB.getInstance.init(
    rootPath: PathUtil.getConfigPath(name: 'recent.db.json'),
  );
  // db
  final db = TDB.getInstance();
  db.setAdapter<Apyar>(ApyarAdapter());
  db.setAdapter<ApyarContent>(ApyarContentAdapter());
  db.setAdapter<Bookmark>(BookmarkAdapter());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ApyarProvider()),
        ChangeNotifierProvider(create: (context) => BookmarkProvider()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => FetchItemResponseCubit()..init()),
          BlocProvider(create: (context) => ApyarBookmarkListCubit()),
          BlocProvider(create: (context) => ApyarListCubit(context.read<ApyarBookmarkListCubit>())),
        ],
        child: const MyApp(),
      ),
    ),
  );
}
