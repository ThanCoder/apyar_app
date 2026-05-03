import 'package:apyar_app/core/interfaces/db/database_interface.dart';
import 'package:apyar_app/core/models/apyar_content.dart';
import 'package:sm_db/sm_db.dart';

class ContentSmdbDatabase extends DatabaseInterface<ApyarContent> {
  final db = SMDB.getInstance();
  JsonDBBox<ApyarContent> get _box => db.getBox<ApyarContent>();

  @override
  Future<ApyarContent?> add(ApyarContent value) async {
    final content = await _box.add(value);
    if (content == null) return null;
    return content.copyWith(autoId: content.id);
  }

  @override
  Future<bool> deleteById(int id) async {
    return await _box.deleteById(id);
  }

  @override
  Future<List<ApyarContent>> getAll({int? parentId}) async {
    final list = <ApyarContent>[];
    for (var item in await _box.getAll(parentId: parentId)) {
      list.add(item.copyWith(autoId: item.id));
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
    return await _box.getOne(test, parentId: parentId);
  }
}
