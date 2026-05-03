import 'package:apyar_app/core/interfaces/db/database_interface.dart';
import 'package:apyar_app/core/models/apyar.dart';

import 'package:t_db/t_db.dart';

class ApyarTdbDatabase extends DatabaseInterface<Apyar> {
  final db = TDB.getInstance();
  TDBox<Apyar> get _box => db.getBox<Apyar>();

  @override
  Future<Apyar?> add(Apyar value) async {
    return await _box.add(value);
  }

  @override
  Future<bool> deleteById(int id) async {
    return await _box.deleteById(id);
  }

  @override
  Future<List<Apyar>> getAll({int? parentId}) async {
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
