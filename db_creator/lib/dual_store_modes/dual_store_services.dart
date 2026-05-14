import 'package:db_creator/dual_store_modes/apyar.dart';
import 'package:db_creator/dual_store_modes/content.dart';
import 'package:dual_store/dual_store.dart';

class DualStoreServices {
  final db = DualStore();

  DualBox<Apyar> get apyarBox => db.getBox<Apyar>();
  DualBox<Content> get contentBox => db.getBox<Content>();

  Future<void> init() async {
    db.registerAdapterNotExists<Apyar>(ApyarAdapter());
    db.registerAdapterNotExists<Content>(ContentAdapter());

    await db.open('/home/thancoder/Downloads/Apyar App/apyar.dual.db');
  }
}
