import 'dart:io';

import 'package:apyar_app/core/interfaces/db/database_interface.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:than_pkg/than_pkg.dart';

class DatabaseServices {
  static String getLocalDatabasePath() {
    return DatabaseInterface.getDatabasePath();
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
    if (dbFile().existsSync() && dbFile().getSize > 5) {
      return true;
    }
    return false;
  }

  static Future<void> deleteAllDB() async {
    if (dbFile().existsSync()) {
      await dbFile().delete();
    }
    if (dbLockFile().existsSync()) {
      await dbLockFile().delete();
    }
  }

  static int getSize() {
    if (dbFile().existsSync()) {
      return dbFile().size;
    }
    return 0;
  }

  static File dbFile() => File(getLocalDatabasePath());
  static File dbLockFile() => File('${dbFile().path}.lock');
}
