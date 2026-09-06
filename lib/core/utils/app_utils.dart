import 'dart:io';

import 'package:cfb_store/cfb_store.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class AppUtils {
  static final AppUtils instance = AppUtils._();
  AppUtils._();
  factory AppUtils() => instance;

  late Directory configDir;
  late Directory cacheDir;

  late String packageName;
  late String version;

  final config = CFBStore.instance;

  Future<void> init() async {
    cacheDir = await getApplicationCacheDirectory();
    configDir = await getApplicationSupportDirectory();

    final info = await PackageInfo.fromPlatform();
    version = info.version;
    packageName = info.packageName;
    await config.open(getConfigPath('app.config.cfb'));
  }

  String getConfigPath([String? name]) {
    if (!configDir.existsSync()) {
      configDir.createSync(recursive: true);
    }
    if (name != null) {
      return configDir.join(name);
    }

    return configDir.path;
  }

  String getCachePath([String? name]) {
    if (!cacheDir.existsSync()) {
      cacheDir.createSync(recursive: true);
    }
    if (name != null) {
      return cacheDir.join(name);
    }

    return cacheDir.path;
  }
}
