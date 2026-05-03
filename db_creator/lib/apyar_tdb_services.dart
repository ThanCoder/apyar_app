import 'package:t_db/t_db.dart';
import 'tdb_models/apyar.dart';
import 'tdb_models/apyar_content.dart';

class ApyarTdbServices {
  static final ApyarTdbServices instance = ApyarTdbServices._();
  ApyarTdbServices._();
  factory ApyarTdbServices() => instance;
  final db = TDB.getInstance();

  TDBox<Apyar> get box => db.getBox<Apyar>();
  TDBox<ApyarContent> get contentBox => db.getBox<ApyarContent>();
  Future<void> init() async {
    db.setAdapterNotExists<Apyar>(ApyarAdapter());
    db.setAdapterNotExists<ApyarContent>(ApyarContentAdapter());
    await db.open('/home/thancoder/Downloads/Apyar App/apyar.db');
  }
}
