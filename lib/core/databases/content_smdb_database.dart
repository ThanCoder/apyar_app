import 'package:apyar_app/core/interfaces/db/database_interface.dart';
import 'package:apyar_app/core/models/apyar_content.dart';
import 'package:apyar_app/core/models/smdb_adapters.dart';
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
    await init();

    final list = <ApyarContent>[];
    for (var item in await _box.getAll(parentId: parentId)) {
      list.add(item.copyWith(autoId: item.id));
    }
    return list;
  }

  @override
  Future<void> init() async {
    if (!db.isOpened) {
      await db.open(getDBFile().path);
    }
    db.registerAdapterNotExists<ApyarContent>(ApyarContentSmdbAdapter());
  }

  @override
  Future<bool> updateById(int id, ApyarContent value) async {
    return await _box.updateById(id, value: value);
  }

  @override
  Future<ApyarContent?> getOne(
    bool Function(ApyarContent value) test, {
    int? parentId,
  }) async {
    return await _box.getOne(test, parentId: parentId);
  }
}
