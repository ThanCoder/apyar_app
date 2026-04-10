import 'dart:async';
import 'dart:io';

import 'package:apyar_app/app/ui/database_manager/database_services.dart';
import 'package:apyar_app/more_libs/setting/core/path_util.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/functions/index.dart';
import 'package:t_widgets/progress_manager/progress_dialog.dart';
import 'package:t_widgets/progress_manager/progress_manager_interface.dart';
import 'package:t_widgets/progress_manager/progress_message.dart';

class ExportDatabaseListTile extends StatefulWidget {
  const ExportDatabaseListTile({super.key});

  @override
  State<ExportDatabaseListTile> createState() => _ExportDatabaseListTileState();
}

class _ExportDatabaseListTileState extends State<ExportDatabaseListTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Export Database'),
        subtitle: Text(
          'Size: ${DatabaseServices.dbFile().lengthSync().fileSizeLabel()}',
        ),
        onTap: _export,
      ),
    );
  }

  void _export() async {
    showTConfirmDialog(
      context,
      contentText: 'DB ကို အပြင်ထုတ်ချင်တာ သေချာပြီလား?',
      submitText: 'Export',
      onSubmit: () => showProgressDialog(
        context: context,
        barrierDismissible: false,
        progressManager: _ExportDBProgressManager(),
      ),
    );
  }
}

class _ExportDBProgressManager extends ProgressManagerInterface {
  bool isCancel = false;
  @override
  void cancel() {
    isCancel = true;
  }

  @override
  Future<void> start(StreamController<ProgressMessage> streamController) async {
    try {
      streamController.add(ProgressMessage.preparing());
      final outFile = File(PathUtil.getOutPath(name: 'apyar.db'));
      await PathUtil.copyWithProgress(
        File(DatabaseServices.getLocalDatabasePath()),
        destFile: outFile,
        isCancel: () => isCancel,
        onProgerss: (total, loaded) {
          streamController.add(
            ProgressMessage.progress(
              index: 0,
              indexLength: 1,
              progress: loaded / total,
              message: 'DB File Exporting...',
            ),
          );
        },
      );
      streamController.add(
        ProgressMessage.done(
          message: 'DB File ထုတ်ပြီးပါပြီ။\nPath: `${outFile.path}`',
        ),
      );

      await Future.delayed(Duration(seconds: 1));

      streamController.close();
    } catch (e) {
      streamController.addError(e);
    }
  }
}
