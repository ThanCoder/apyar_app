import 'dart:io';

import 'package:apyar_app/core/db/du_db.dart';
import 'package:apyar_app/core/utils/app_utils.dart';
import 'package:apyar_app/keys.dart';
import 'package:apyar_app/platform_app.dart';
import 'package:flutter/material.dart';
import 'package:than_pkg_linux/than_pkg_linux.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // home/thancoder/Documents/apyar.store

  await AppUtils.instance.init();

  if (Platform.isLinux) {
    ThanPkgLinux.getInstance.window.setWindowSize(
      width: AppUtils.instance.config.getDouble(appWidthkey, 600).toInt(),
      height: AppUtils.instance.config.getDouble(appHeightkey, 400).toInt(),
    );
  }

  await DuDB.instance.init();
  await DuDB.instance.open('/home/thancoder/Documents/apyar.store');

  runApp(const PlatformApp());
}
