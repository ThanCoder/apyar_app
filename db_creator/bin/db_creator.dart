import 'dart:io';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:db_creator/apyar_smdb_services.dart';
import 'package:db_creator/dual_store_modes/apyar.dart';
import 'package:db_creator/dual_store_modes/content.dart';
import 'package:db_creator/dual_store_modes/dual_store_services.dart';

void main(List<String> arguments) async {
  final dir = Directory('smdb_files');
  if (!dir.existsSync()) {
    await dir.create();
  }
  // final dual = DualStoreServices();
  // await dual.init();

  // for (var apyar in await dual.apyarBox.getAll()) {
  //   print(apyar);
  //   final content = await dual.contentBox.findOne(
  //     (value) => value.apyarId == apyar.id,
  //   );
  //   if (content == null) continue;

  //   print('content: id: ${content.id} - CH: ${content.chapter}');
  //   print('big string data');
  //   final bigStr = await dual.contentBox.readBigDataAsString(content);
  //   if (bigStr == null) continue;
  //   File(apyar.title).writeAsString(bigStr);
  //   break;
  // }
  // await dual.db.close();
}

Future<void> addDualDB(Directory dir) async {
  final dual = DualStoreServices();
  await dual.init();

  for (var file in dir.listSync(followLinks: false)) {
    final title = file.getName();
    final id = await dual.apyarBox.add(
      Apyar(title: title, date: DateTime.now()),
    );
    // content
    final bigString = await file.getFile.readAsString();

    final contentId = await dual.contentBox.addWithBigDataString(
      Content(apyarId: id, chapter: 1),
      bigString: bigString,
    );
    print('Add T: $title - contentId: $contentId');
  }

  await dual.db.close();
}

Future<void> exportFilesFromSmdb(Directory dir) async {
  final db = ApyarSmdbServices.instance;
  await db.init();
  final Map<int, String> apyarMap = {};

  await for (var apyar in db.box.getAllStream()) {
    apyarMap[apyar.id] = apyar.title;
  }

  // write content
  int i = 0;
  await for (var content in db.contentBox.getAllStream()) {
    final title = apyarMap[content.apyarId];

    print('Content ID: ${content.id} - Chapter: ${content.chapter}');

    await File('${dir.path}/$title').writeAsString(content.body);
    i++;
    print('Write Contents: $i');
  }
}
