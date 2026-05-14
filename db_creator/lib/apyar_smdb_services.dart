import 'package:db_creator/smdb_models/apyar.dart';
import 'package:db_creator/smdb_models/apyar_content.dart';
import 'package:sm_db/sm_db.dart';

class ApyarSmdbServices {
  static final ApyarSmdbServices instance = ApyarSmdbServices._();
  ApyarSmdbServices._();
  factory ApyarSmdbServices() => instance;
  final db = SMDB.getInstance();
  final config = SMDBConfig.empty().copyWith(dbType: 'APYD');

  JsonDBBox<Apyar> get box => db.getBox<Apyar>();
  JsonDBBox<Content> get contentBox => db.getBox<Content>();

  Future<void> init() async {
    await db.open(
      '/home/thancoder/Downloads/Apyar App/apyar.apyd.db',
      config: config,
    );
    db.registerAdapterNotExists<Apyar>(ApyarAdapter());
    db.registerAdapterNotExists<Content>(ApyarContentAdapter());
  }

  Future<List<Apyar>> getAll() async {
    return box.getAll();
  }

  Future<bool> deleteById(int id) async {
    // delete content
    for (var content in await getContentListByApyarId(id)) {
      await deleteContentById(content.id);
    }
    // dele apyar
    return await box.deleteById(id);
  }

  Future<Apyar?> add(Apyar apyar) async {
    return await box.add(apyar);
  }

  Future<bool> updateById(int id, Apyar apyar) async {
    return await box.updateById(id, value: apyar);
  }

  Future<bool> deleteContentById(int id) async {
    return await contentBox.deleteById(id);
  }

  Future<Content?> getContentByApyarId(int id, {int chapter = 1}) async {
    // print('id: $id - ch: $chapter');
    final res = await contentBox.getByParentId(id);
    return res;
  }

  Future<List<Content>> getContentListByApyarId(int id) async {
    final list = await contentBox.getAll();
    return list.where((e) => e.apyarId == id).toList();
  }

  Future<Content?> addContentByApyarId(int id, Content value) async {
    return await contentBox.add(value);
  }

  Future<bool> updateContentByApyarId(int id, Content value) async {
    return await contentBox.updateById(id, value: value);
  }

  Future<void> setContentByApyarId(int id, Content value) async {
    final found = await getContentByApyarId(id, chapter: value.chapter);
    if (found != null) {
      //delete
      await deleteContentById(id);
    }
    //add
    await addContentByApyarId(id, value);
  }
}
