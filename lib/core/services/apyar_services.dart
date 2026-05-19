import 'package:apyar_app/core/services/dual_store_services.dart';

class ApyarServices {
  static final ApyarServices instance = ApyarServices._();
  ApyarServices._();
  factory ApyarServices() => instance;

  static DualStoreServices? _services;
  Future<DualStoreServices> getDualStore() async {
    if (_services != null) return _services!;
    _services = DualStoreServices();
    await _services!.init();
    return _services!;
  }

  Future<void> close() async {
    if (_services != null) {
      await _services!.db.close();
      _services = null;
    }
  }
}
