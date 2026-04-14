import 'dart:io';

import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:db_creator/apyar_smdb_services.dart';
import 'package:db_creator/apyar_tdb_services.dart';
import 'package:db_creator/smdb_models/apyar.dart';
import 'package:db_creator/smdb_models/apyar_content.dart';

void main(List<String> arguments) async {
  await ApyarSmdbServices.instance.init();

  final dir = Directory('smdb_files');
  if (!dir.existsSync()) {
    await dir.create();
  }
  // await _extractAllFromSmdb(dir);
}

Future<void> _extractAllFromSmdb(Directory dir) async {
  final db = ApyarSmdbServices.instance;
  await db.init();
  final list = await db.getAll();
  int i = 0;
  for (var apyar in list) {
    i++;
    final content = await db.getContentByApyarId(apyar.id);
    if (content == null) {
      continue;
    }
    if (content.body.isEmpty) {
      continue;
    }
    print(apyar.title);
    await File('${dir.path}/${apyar.title}').writeAsString(content.body);
    print('Progress: $i-${list.length}');
    // break;
  }
}

Future<void> _addAllSmdb(Directory dir) async {
  final db = ApyarSmdbServices.instance;
  int i = 0;
  final list = dir.listSync(followLinks: false);
  for (var file in list) {
    if (!file.isFile) continue;
    if (file.size == 0) continue;

    final apyar = await db.add(
      Apyar(title: file.getName(), date: DateTime.now()),
    );
    if (apyar == null) continue;
    i++;
    final body = await File(file.path).readAsString();
    await db.addContentByApyarId(
      apyar.id,
      ApyarContent(
        apyarId: apyar.id,
        chapter: 1,
        body: body,
        date: DateTime.now(),
      ),
    );
    print('Title: ${apyar.title}');
    print('- Progress: $i-${list.length}');
  }
}

Future<void> _extractAllFromTDB(Directory dir) async {
  await ApyarTdbServices.instance.init();
  final list = await ApyarTdbServices.instance.getAll();
  int i = 0;
  for (var apyar in list) {
    i++;
    final content = await ApyarTdbServices.instance.getContentByApyarId(
      apyar.autoId,
    );
    if (content == null) {
      continue;
    }
    if (content.body.isEmpty) {
      print('body: ${content.body}');
      continue;
    }
    print(apyar.title);
    await File('${dir.path}/${apyar.title}').writeAsString(content.body);
    print('Progress: $i-${list.length}');
    // break;
  }
}
