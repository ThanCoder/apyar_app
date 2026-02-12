import 'dart:io';

import 'package:apyar_app/app/ui/database_manager/database_services.dart';
import 'package:apyar_app/app/ui/database_manager/database_manager_screen.dart';
import 'package:apyar_app/more_libs/setting/core/path_util.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class AddLocalDatabaseListTile extends StatefulWidget {
  const AddLocalDatabaseListTile({super.key});

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
      final res = await openFile(
        acceptedTypeGroups: [
          XTypeGroup(label: 'Database File', extensions: ['db']),
        ],
      );
      if (res == null) return;
      final path = res.path;
      if (!path.endsWith('.db')) return;
      await PathUtil.copyWithProgress(
        File(path),
        destFile: File(DatabaseServices.getLocalDatabasePath()),
      );
      databaseManagerScreenStateNotifier.value = !databaseManagerScreenStateNotifier.value;
    } catch (e) {
      if (!mounted) return;
      showTMessageDialogError(context, e.toString());
    }
  }
}
