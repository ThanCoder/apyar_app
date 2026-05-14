import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/models/content.dart';
import 'package:apyar_app/more_libs/setting/core/path_util.dart';
import 'package:dual_store/dual_store.dart';

class DualStoreServices {
  final db = DualStore();

  String get dbPath => PathUtil.getDatabasePath(name: 'apyar.dual.db');

  DualBox<Apyar> get apyarBox => db.getBox<Apyar>();
  DualBox<Content> get contentBox => db.getBox<Content>();

  Future<void> init() async {
    db.registerAdapterNotExists<Apyar>(ApyarAdapter());
    db.registerAdapterNotExists<Content>(ContentAdapter());

    await db.open(dbPath);
  }
}
