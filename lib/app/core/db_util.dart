import 'dart:io';

import 'package:apyar_app/more_libs/setting/core/path_util.dart';
import 'package:than_pkg/extensions/index.dart';

String getLocalDatabasePath() {
  return PathUtil.getDatabasePath(name: 'apyar.db');
}

bool isLocalDatabaseExists() {
  final dbFile = File(getLocalDatabasePath());
  if (dbFile.existsSync()) {
    // check db size
    final minSize = 10; //10 byte
    if (dbFile.getSize > minSize) {
      return true;
    }
  }
  return false;
}
