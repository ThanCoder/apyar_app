import 'package:apyar_app/core/interfaces/db/database_interface.dart';
import 'package:t_db/t_db.dart';
import 'package:apyar_app/core/models/apyar_content.dart';

class ContentTdbDatabase extends DatabaseInterface<ApyarContent> {
  final db = TDB.getInstance();
  TDBox<ApyarContent> get _box => db.getBox<ApyarContent>();

  @override
  Future<ApyarContent?> add(ApyarContent value) async {
    return await _box.add(value);
  }

  @override
  Future<bool> deleteById(int id) async {
    return await _box.deleteById(id);
  }

  @override
  Future<List<ApyarContent>> getAll({int? parentId}) async {
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
