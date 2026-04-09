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
    return await _box.deleteById(id);
  }

  Future<int> add(Apyar apyar) async {
    return await _box.add(apyar);
  }

  Future<ApyarContent?> getContentByApyarId(int id) async {
    return await _contentBox.getOne((e) => e.apyarId == id);
  }
}
