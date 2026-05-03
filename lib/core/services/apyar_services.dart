import 'package:apyar_app/core/databases/apyar_smdb_database.dart';
import 'package:apyar_app/core/databases/apyar_tdb_database.dart';
import 'package:apyar_app/core/databases/content_smdb_database.dart';
import 'package:apyar_app/core/databases/content_tdb_database.dart';
import 'package:apyar_app/core/interfaces/db/database_interface.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/models/apyar_content.dart';

class ApyarServices {
  static final ApyarServices instance = ApyarServices._();
  ApyarServices._();
  factory ApyarServices() => instance;

  final Map<ApyarDBType, Map<Type, DatabaseInterface>> _db = {};

  void clearAllDatabaseCached() {
    _db.clear();
  }

  DatabaseInterface<T> getApyarDB<T extends Apyar>({ApyarDBType? type}) {
    return getDB<T>(type: type ?? DatabaseInterface.getDBType());
  }

  DatabaseInterface<T> getContentDB<T extends ApyarContent>({
    ApyarDBType? type,
  }) {
    return getDB<T>(type: type ?? DatabaseInterface.getDBType());
  }

  DatabaseInterface<T> getDB<T>({ApyarDBType type = ApyarDBType.tdb}) {
    if (_db[type] == null) _db[type] = {}; // Null check logic

    if (_db[type]![T] == null) {
      DatabaseInterface? newDb;
      if (T == Apyar) {
        newDb = (type == ApyarDBType.tdb)
            ? ApyarTdbDatabase()
            : ApyarSmdbDatabase();
      } else if (T == ApyarContent) {
        newDb = (type == ApyarDBType.tdb)
            ? ContentTdbDatabase()
            : ContentSmdbDatabase();
      }

      if (newDb != null) {
        _db[type]![T] = newDb;
      }
    }

    return _db[type]![T] as DatabaseInterface<T>;
  }
}
