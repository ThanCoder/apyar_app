import 'package:t_db/t_db.dart';
import 'tdb_models/apyar.dart';
import 'tdb_models/apyar_content.dart';

class ApyarTdbServices {
  static final ApyarTdbServices instance = ApyarTdbServices._();
  ApyarTdbServices._();
  factory ApyarTdbServices() => instance;
  final db = TDB.getInstance();

  TDBox<Apyar> get box => db.getBox<Apyar>();
  TDBox<Content> get contentBox => db.getBox<Content>();
  Future<void> init() async {
    db.setAdapterNotExists<Apyar>(ApyarAdapter());
    db.setAdapterNotExists<Content>(ApyarContentAdapter());
    await db.open('/home/thancoder/Downloads/Apyar App/apyar.db');
  }
}
