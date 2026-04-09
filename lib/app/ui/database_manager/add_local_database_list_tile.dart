import 'dart:io';

import 'package:apyar_app/app/ui/database_manager/database_services.dart';
import 'package:apyar_app/more_libs/setting/core/path_util.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class AddLocalDatabaseListTile extends StatefulWidget {
  final void Function() onCheckDB;
  const AddLocalDatabaseListTile({super.key, required this.onCheckDB});

  @override
  State<AddLocalDatabaseListTile> createState() =>
      _AddLocalDatabaseListTileState();
}

class _AddLocalDatabaseListTileState extends State<AddLocalDatabaseListTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Add Local Database'),
        subtitle: Text('Database ကို ထည့်သွင်းမယ်'),
        onTap: _addLocalDB,
      ),
    );
  }

  void _addLocalDB() async {
    try {
      if (await Permission.storage.isDenied) {
        await Permission.storage.request();
      }
      if (await Permission.manageExternalStorage.isDenied) {
        await Permission.manageExternalStorage.request();
      }

      final res = await openFile(
        acceptedTypeGroups: [
          XTypeGroup(label: 'Database File', extensions: ['db']),
        ],
      );
      if (res == null) return;
      // if (!mounted) return;
      // showTMessageDialog(context, 'Path: ${res.path}');

      // del db lock
      if (DatabaseServices.dbLockFile().existsSync()) {
        await DatabaseServices.dbLockFile().delete();
      }
      final sourceFile = File(res.path);
      final inputStream = sourceFile.openRead();
      final outputStream = DatabaseServices.dbFile().openWrite();

      await inputStream.pipe(outputStream);
      await outputStream.close();

      // copy
      // await PathUtil.copyWithProgress(
      //   File(res.path),
      //   destFile: DatabaseServices.dbFile(),
      // );

      widget.onCheckDB();
    } catch (e) {
      if (!mounted) return;
      showTMessageDialogError(context, e.toString());
    }
  }
}
