import 'package:apyar_app/core/controllers/i_controller.dart';
import 'package:apyar_app/core/db/du_db.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/utils/app_util.dart';
import 'package:apyar_app/keys.dart';

class ApLoad extends IControllerEvent {}

class ApyarController extends IController {
  List<Apyar> list = [];
  final map = <String, Apyar>{};
  bool isLoading = false;
  final db = DuDB.instance;
  final _config = AppUtil.instance.config;

  @override
  Future<void> init() async {
    String dbPath = AppUtil.instance.getConfigPath('apyar.db.du');
    if (_config.getBool(appDatabseCustomPathEnableKey)) {
      dbPath = AppUtil.instance.config.getString(appDatabseCustomPathKey);
    }
    await DuDB.instance.open(dbPath);
    db.apyarBox.events.all.listen((event) {
      // print('[ApyarController:event]: $event');
      fetchApyarList();
    });
    fetchApyarList();
  }

  Future<void> fetchApyarList() async {
    map.clear();
    isLoading = true;
    addEvent(ApLoad());

    await Future.delayed(Duration(seconds: 2));

    list = await db.apyarBox.getAll();
    for (var ap in list) {
      map[ap.generatedId.toString()] = ap;
    }
    isLoading = false;
    addEvent(ApLoad());
  }
}
