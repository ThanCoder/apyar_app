import 'dart:convert';
import 'dart:io';

import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/more_libs/setting/core/path_util.dart';

class ApyarBookmarkServices {
  static final ApyarBookmarkServices instance = ApyarBookmarkServices._();
  ApyarBookmarkServices._();
  factory ApyarBookmarkServices() => instance;

  File get dbFile =>
      File(PathUtil.getLibaryPath(name: 'apyar-bookmark.db.json'));

  Future<void> setAll(List<Apyar> list) async {
    final contents = list.map((e) => e.toMap()).toList();
    await dbFile.writeAsString(jsonEncode(contents));
  }

  Future<List<Apyar>> getAll() async {
    if (!dbFile.existsSync()) return [];
    final source = await dbFile.readAsString();
    if (source.isEmpty) return [];
    List<dynamic> resList = jsonDecode(source);
    return resList.map((e) => Apyar.fromMap(e)).toList();
  }
}
