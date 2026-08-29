import 'dart:io';

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

  Future<void> init() async {
    cacheDir = await getApplicationCacheDirectory();
    configDir = await getApplicationSupportDirectory();

    final info = await PackageInfo.fromPlatform();
    version = info.version;
    packageName = info.packageName;
  }
}
