import 'dart:io';

import 'package:apyar_app/bloc_app/cubits/apyar_bookmark_list_cubit.dart';
import 'package:apyar_app/bloc_app/cubits/apyar_list_cubit.dart';
import 'package:apyar_app/bloc_app/cubits/fetch_item_response_cubit.dart';

import 'package:apyar_app/more_libs/setting/core/path_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    defaultImageAssetsPath: 'assets/apyar_log_3.jpg',
    isDarkTheme: () => Setting.getAppConfig.isDarkTheme,
    getCachePath: (url, cacheName) => PathUtil.getCachePath(name: cacheName),
    // onDownloadImage: (url, savePath) async {
    //   await client.download(url, savePath: savePath);
    // },
    // getCachePath: (url) => PathUtil.getCachePath(
    //   name: StringPathExtensions(url.getCleanBackSlash).getName(),
    // ),
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

  await copyDatabase();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FetchItemResponseCubit()..init()),
        BlocProvider(create: (context) => ApyarBookmarkListCubit()),
        BlocProvider(
          create: (context) =>
              ApyarListCubit(context.read<ApyarBookmarkListCubit>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> copyDatabase() async {
  final dbFile = File(PathUtil.getDatabasePath(name: 'apyar.dual.db'));

  if (!dbFile.existsSync()) {
    // 1. Asset ကနေ byte data ကို load လုပ်တယ်
    final data = await rootBundle.load('assets/apyar.dual.db');

    // 2. File ကို Write mode နဲ့ ဖွင့်တယ်
    final buffer = data.buffer.asUint8List();
    final ios = dbFile.openWrite();

    // 3. Chunk အလိုက် ခွဲပြီး ရေးတယ် (ဥပမာ- တစ်ခါရေးရင် 1MB နှုန်း)
    const int chunkSize = 1024 * 1024; // 1MB
    int offset = 0;

    while (offset < buffer.length) {
      int end = offset + chunkSize;
      if (end > buffer.length) end = buffer.length;

      // အပိုင်းလိုက် ထုတ်ယူပြီး stream ထဲ ထည့်ရေးတယ်
      ios.add(buffer.sublist(offset, end));
      offset = end;
    }

    // 4. အားလုံးပြီးရင် ပိတ်ပေးရမယ်
    await ios.flush();
    await ios.close();

    debugPrint("Database copy finished.");
  }
}
