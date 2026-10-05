import 'package:apyar_app/core/controllers/apyar/apyar_controller.dart';
import 'package:apyar_app/core/controllers/i_controller.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/utils/app_util.dart';
import 'package:apyar_app/keys.dart';
import 'package:cfb_store/cfb_store.dart';

class FavLoaded extends IControllerEvent {}

class FavController extends IController {
  final _cf = CFBStore();
  final _apCon = ControllerManager.read<ApyarController>();
  final _config = AppUtil.instance.config;
  List<String> idList = [];

  List<Apyar> get apyarList {
    List<Apyar> res = [];
    for (var id in idList) {
      final ap = _apCon.map[id];
      if (ap == null) continue;
      res.add(ap);
    }
    return res;
  }

  @override
  Future<void> init() async {
    if (_config.getBool(appDatabseCustomPathEnableKey)) {
      await _cf.open(
        AppUtil.instance.getPlatfromExternalConfigPath('fav.db.cfb'),
      );
    } else {
      await _cf.open(AppUtil.instance.getConfigPath('fav.db.cfb'));
    }

    idList = _cf.getList('list');
    addEvent(FavLoaded());
  }

  // Future<void> reloadIfNotExists() async {
  //   if(_cf.)
  //   await _cf.reload();
  // }

  bool exists(String apyarId) {
    return idList.contains(apyarId);
  }

  void add(String apyarId) {
    idList.insert(0, apyarId);
    _save();
  }

  void remove(String apyarId) {
    idList.remove(apyarId);
    _save();
  }

  void _save() async {
    await _cf.putAndWriteAll('list', idList);
    addEvent(FavLoaded());
  }
}
