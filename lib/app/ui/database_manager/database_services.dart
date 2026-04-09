import 'dart:io';

import 'package:apyar_app/more_libs/setting/core/path_util.dart';
import 'package:t_db/t_db.dart';
import 'package:than_pkg/than_pkg.dart';

class DatabaseServices {
  static String getLocalDatabasePath() {
    return PathUtil.getDatabasePath(name: 'apyar.db');
  }

  static bool isLocalDatabaseExists() {
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

  static Future<bool> isDatabaseRecordExists() async {
    final db = TDB.getInstance();
    await db.open(DatabaseServices.getLocalDatabasePath());
    // print('isDataRecordCreatedExists: ${db.isDataRecordCreatedExists}');
    return db.isDataRecordCreatedExists;
  }

  static Future<void> deleteAllDB() async {
    if (dbFile().existsSync()) {
      await dbFile().delete();
    }
    if (dbLockFile().existsSync()) {
      await dbLockFile().delete();
    }
  }

  static File dbFile() => File(getLocalDatabasePath());
  static File dbLockFile() => File('${dbFile().path}.lock');
}
