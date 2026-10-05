import 'dart:io';

import 'package:apyar_app/core/controllers/apyar/apyar_controller.dart';
import 'package:apyar_app/core/controllers/i_controller.dart';
import 'package:apyar_app/core/db/du_db.dart';
import 'package:apyar_app/core/utils/app_util.dart';
import 'package:apyar_app/keys.dart';
import 'package:apyar_app/platform_app.dart';
import 'package:apyar_app/platforms/pages/fav/fav_controller.dart';
import 'package:flutter/material.dart';
import 'package:than_pkg_linux/than_pkg_linux.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // home/thancoder/Documents/apyar.store

  await AppUtil.instance.init();

  if (Platform.isLinux) {
    ThanPkgLinux.getInstance.window.setWindowSize(
      width: AppUtil.instance.config.getDouble(appWidthkey, 600).toInt(),
      height: AppUtil.instance.config.getDouble(appHeightkey, 400).toInt(),
    );
  }
  await DuDB.instance.init();

  ControllerManager.register(ApyarController());
  ControllerManager.register(FavController());
  await ControllerManager.initAll();

  runApp(const PlatformApp());
}
