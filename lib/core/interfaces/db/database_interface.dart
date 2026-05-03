import 'dart:io';

import 'package:apyar_app/more_libs/setting/core/path_util.dart';
import 'package:sm_db/sm_db.dart';
import 'package:t_db/t_db.dart';
import 'package:than_pkg/than_pkg.dart';

enum ApyarDBType {
  tdb,
  smdb;

  static ApyarDBType getName(String name) {
    if (name == smdb.name) {
      return smdb;
    }
    return tdb;
  }
}

abstract class DatabaseInterface<T> {
  static Future<void> openDatabases() async {
    if (getDBType() == ApyarDBType.smdb) {
      await SMDB.getInstance().open(getDatabasePath());
      return;
    }
    await TDB.getInstance().open(getDatabasePath());
  }

  static Future<void> setDBType(ApyarDBType type) async {
    await TRecentDB.getInstance.putString('apyar-db-type', type.name);
  }

  static ApyarDBType getDBType() {
    return ApyarDBType.getName(
      TRecentDB.getInstance.getString('apyar-db-type'),
    );
  }

  static String getDBName() {
    if (getDBType() == ApyarDBType.smdb) {
      return 'apyar.smdb';
    }
    return 'apyar.db';
  }

  static String getDatabasePath() {
    return PathUtil.getDatabasePath(name: getDBName());
  }

  Future<List<T>> getAll({int? parentId});
  Future<T?> getOne(bool Function(T value) test, {int? parentId});
  Future<bool> deleteById(int id);
  Future<T?> add(T value);
  Future<bool> updateById(int id, T value);

  File getDBFile() {
    return File(getDatabasePath());
  }
}
