import 'package:apyar_app/app/core/models/apyar.dart';
import 'package:flutter/material.dart';
import 'package:t_db/t_db.dart';

final _box = TDB.getInstance().getBox<Apyar>();

class ApyarProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Apyar> list = [];

  Future<void> init({
    bool isUsedCache = true,
    void Function(String message)? onError,
  }) async {
    try {
      if (isUsedCache && list.isNotEmpty) return;

      isLoading = true;
      notifyListeners();

      list = await _box.getAll();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      onError?.call(e.toString());
    }
  }

  void sortRandom() {
    list.shuffle();
    notifyListeners();
  }
}
