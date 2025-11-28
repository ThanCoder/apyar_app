import 'package:apyar_app/app/core/models/bookmark.dart';
import 'package:flutter/material.dart';
import 'package:t_db/t_db.dart';

final _box = TDB.getInstance().getBox<Bookmark>();

class BookmarkProvider extends ChangeNotifier with TBoxEventListener {
  bool isLoading = false;
  List<Bookmark> list = [];

  BookmarkProvider() {
    _box.addListener(this);
  }

  Future<void> init({void Function(String message)? onError}) async {
    try {
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

  void delete(Bookmark bookmark) async {
    final index = list.indexWhere((e) => e.autoId == bookmark.autoId);
    if (index == -1) return;
    list.removeAt(index);
    await _box.deleteById(bookmark.autoId);
    notifyListeners();
  }

  @override
  void onTBoxDatabaseChanged(TBEventType event, int? id) async {
    if (id == null) return;
    if (event == TBEventType.delete) {
      final index = list.indexWhere((e) => e.autoId == id);
      if (index == -1) return;
      list.removeAt(index);
      notifyListeners();
      return;
    }
    if (event == TBEventType.add) {
      final found = await _box.getOne((value) => value.autoId == id);
      if (found == null) return;
      list.add(found);
      notifyListeners();
    }
    if (event == TBEventType.update) {
      final index = list.indexWhere((e) => e.autoId == id);
      if (index == -1) return;
      final found = await _box.getOne((value) => value.autoId == id);
      if (found == null) return;
      list[index] = found;
      notifyListeners();
    }
  }
}
