import 'package:apyar_app/app/ui/database_manager/database_services.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/models/apyar_content.dart';
import 'package:t_db/t_db.dart';

class ApyarServices {
  static final ApyarServices instance = ApyarServices._();
  ApyarServices._();
  factory ApyarServices() => instance;
  final db = TDB.getInstance();

  TDBox<Apyar> get _box => db.getBox<Apyar>();
  TDBox<ApyarContent> get _contentBox => db.getBox<ApyarContent>();

  Future<List<Apyar>> getAll() async {
    if (!db.isOpened) {
      await db.open(DatabaseServices.getLocalDatabasePath());
    }
    return _box.getAll();
  }

  Future<bool> deleteById(int id) async {
    // delete content
    for (var content in await getContentListByApyarId(id)) {
      await deleteContentById(content.autoId);
    }
    // dele apyar
    return await _box.deleteById(id);
  }

  Future<int> add(Apyar apyar) async {
    return await _box.add(apyar);
  }

  Future<bool> updateById(int id, Apyar apyar) async {
    return await _box.updateById(id, apyar);
  }

  Future<bool> deleteContentById(int id) async {
    return await _contentBox.deleteById(id);
  }

  Future<ApyarContent?> getContentByApyarId(int id, {int chapter = 1}) async {
    // print('id: $id - ch: $chapter');
    final res = await _contentBox.getOne(
      (e) => e.apyarId == id && e.chapter == chapter,
    );
    return res;
  }

  Future<List<ApyarContent>> getContentListByApyarId(int id) async {
    final list = await _contentBox.getAll();
    return list.where((e) => e.apyarId == id).toList();
  }

  Future<int> addContentByApyarId(int id, ApyarContent value) async {
    return await _contentBox.add(value);
  }

  Future<void> setContentByApyarId(int id, ApyarContent value) async {
    final found = await getContentByApyarId(id, chapter: value.chapter);
    if (found != null) {
      //delete
      await deleteContentById(id);
    }
    //add
    await addContentByApyarId(id, value);
  }
}
