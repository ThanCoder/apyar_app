import 'dart:convert';
import 'dart:io';

import 'package:apyar_app/bloc_app/ui/fetcher/fetcher_types.dart';
import 'package:apyar_app/more_libs/setting/core/path_util.dart';

class FetchItemResponseBookmarkServices {
  static final FetchItemResponseBookmarkServices instance =
      FetchItemResponseBookmarkServices._();
  FetchItemResponseBookmarkServices._();
  factory FetchItemResponseBookmarkServices() => instance;

  Future<void> setList(List<FetchItemResponse> list) async {
    final contents = list.map((e) => e.toJson()).toList();
    await _getDBFile().writeAsString(jsonEncode(contents));
  }

  Future<List<FetchItemResponse>> getList() async {
    List<FetchItemResponse> list = [];
    if (_getDBFile().existsSync()) {
      final source = await _getDBFile().readAsString();
      if (source.isEmpty) return list;
      List<dynamic> resList = jsonDecode(source);
      list = resList.map((e) => FetchItemResponse.fromJson(e)).toList();
    }
    return list;
  }

  File _getDBFile() => File(
    PathUtil.getLibaryPath(name: 'fetch-item-response-bookmark.db.json'),
  );
}
