import 'package:apyar_app/core/interfaces/db/database_interface.dart';
import 'package:apyar_app/core/models/tdb_adapters.dart';
import 'package:t_db/t_db.dart';
import 'package:apyar_app/core/models/apyar_content.dart';

class ContentTdbDatabase extends DatabaseInterface<ApyarContent> {
  final db = TDB.getInstance();
  TDBox<ApyarContent> get _box => db.getBox<ApyarContent>();

  @override
  Future<void> init() async {
    if (!db.isOpened) {
      await db.open(getDBFile().path);
    }
    db.setAdapterNotExists<ApyarContent>(ApyarContentTdbAdapter());
  }

  @override
  Future<ApyarContent?> add(ApyarContent value) async {
    final id = await _box.add(value);
    return value.copyWith(autoId: id, id: id);
  }

  @override
  Future<bool> deleteById(int id) async {
    return await _box.deleteById(id);
  }

  @override
  Future<List<ApyarContent>> getAll({int? parentId}) async {
    await init();

    final list = <ApyarContent>[];
    for (var item in await _box.getAll()) {
      if (parentId != null) {
        if (item.apyarId != parentId) continue;
        list.add(item.copyWith(id: item.autoId));
      } else {
        list.add(item.copyWith(id: item.autoId));
      }
    }

    return list;
  }

  @override
  Future<bool> updateById(int id, ApyarContent value) async {
    return await _box.updateById(id, value);
  }

  @override
  Future<ApyarContent?> getOne(
    bool Function(ApyarContent value) test, {
    int? parentId,
  }) async {
    return await _box.getOne(test);
  }
}
