import 'package:apyar_app/core/interfaces/db/database_interface.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:sm_db/sm_db.dart';

class ApyarSmdbDatabase extends DatabaseInterface<Apyar> {
  final db = SMDB.getInstance();
  JsonDBBox<Apyar> get _box => db.getBox<Apyar>();

  @override
  Future<Apyar?> add(Apyar value) async {
    final apyar = await _box.add(value);
    if (apyar == null) return null;
    return apyar.copyWith(autoId: apyar.id);
  }

  @override
  Future<bool> deleteById(int id) async {
    return await _box.deleteById(id);
  }

  @override
  Future<List<Apyar>> getAll({int? parentId}) async {
    final list = <Apyar>[];
    for (var item in await _box.getAll(parentId: parentId)) {
      list.add(item.copyWith(autoId: item.id));
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
    return await _box.getOne(test, parentId: parentId);
  }
}
