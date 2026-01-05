import 'package:apyar_app/app/core/extensions/apyar_extensions.dart';
import 'package:apyar_app/app/core/models/apyar.dart';
import 'package:flutter/material.dart';
import 'package:t_db/t_db.dart';
import 'package:t_widgets/t_widgets.dart';

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

      onSort();

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

  // sort
  List<TSort> sortList = TSort.getDefaultList
    ..add(
      TSort(
        id: 1,
        title: 'Random',
        ascTitle: 'Is Random',
        descTitle: 'Title A-Z',
      ),
    );
  int sortId = TSort.getTitleId;
  bool sortAsc = true;

  void setSort(int sortId, bool isAsc) {
    this.sortId = sortId;
    sortAsc = isAsc;
    onSort();
  }

  void onSort() {
    if (sortId == TSort.getTitleId) {
      list.sortTitle(isAToZ: sortAsc);
    }
    if (sortId == TSort.getDateId) {
      list.sortDate(isNewest: !sortAsc);
    }
    if (sortId == 1) {
      if (sortAsc) {
        list.shuffle();
      } else {
        list.sortTitle();
      }
    }

    notifyListeners();
  }
}
