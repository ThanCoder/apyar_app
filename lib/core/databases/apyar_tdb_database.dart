import 'package:apyar_app/core/interfaces/db/database_interface.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/models/tdb_adapters.dart';

import 'package:t_db/t_db.dart';

class ApyarTdbDatabase extends DatabaseInterface<Apyar> {
  final db = TDB.getInstance();
  TDBox<Apyar> get _box => db.getBox<Apyar>();

  @override
  Future<void> init() async {
    if (!db.isOpened) {
      await db.open(getDBFile().path);
    }
    db.setAdapterNotExists<Apyar>(ApyarTdbAdapter());
  }

  @override
  Future<Apyar?> add(Apyar value) async {
    final id = await _box.add(value);
    return value.copyWith(autoId: id);
  }

  @override
  Future<bool> deleteById(int id) async {
    return await _box.deleteById(id);
  }

  @override
  Future<List<Apyar>> getAll({int? parentId}) async {
    await init();
    final list = <Apyar>[];
    for (var item in await _box.getAll()) {
      list.add(item.copyWith(id: item.autoId));
    }

    return list;
  }

  @override
  Future<bool> updateById(int id, Apyar value) async {
    return await _box.updateById(id, value);
  }

  @override
  Future<Apyar?> getOne(
    bool Function(Apyar value) test, {
    int? parentId,
  }) async {
    return await _box.getOne(test);
  }
}
