import 'package:apyar_app/core/db/i_db.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/models/apyar_content.dart';
import 'package:dual_store/dual_store.dart';

class DuDB implements IDB {
  static final DuDB instance = DuDB._();
  DuDB._();
  factory DuDB() => instance;

  final _db = DualStore();

  @override
  Future<void> init() async {
    _db.registerAdapter(ApyarAdapter());
    _db.registerAdapter(ApyarContentAdapter());
  }

  DuBox<Apyar> get apyarBox => _db.getBox<Apyar>();
  DuBox<ApyarContent> get apyarContentBox => _db.getBox<ApyarContent>();

  @override
  Future<void> open(String path) async {
    await _db.open(path);
  }

  @override
  Future<void> close() async {
    await _db.close();
  }
}
