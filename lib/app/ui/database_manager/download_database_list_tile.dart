import 'dart:async';
import 'dart:io';

import 'package:apyar_app/app/ui/database_manager/database_services.dart';
import 'package:apyar_app/app/ui/database_manager/database_manager_screen.dart';
import 'package:flutter/material.dart';
import 'package:t_client/t_client.dart';
import 'package:t_db/t_db.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class DownloadDatabaseListTile extends StatefulWidget {
  const DownloadDatabaseListTile({super.key});

  @override
  State<DownloadDatabaseListTile> createState() =>
      _DownloadDatabaseListTileState();
}

class _DownloadDatabaseListTileState extends State<DownloadDatabaseListTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Downloaded Database'),
        subtitle: Text(
          'Database ကို Download ${DatabaseServices.isLocalDatabaseExists() ? 'လုပ်ထားပြီးပါပြီ' : 'လုပ်ရပါမယ်'}',
        ),
        onTap: _downloadConfirm,
      ),
    );
  }

  bool get isExistsDB {
    return DatabaseServices.isLocalDatabaseExists();
  }

  void _downloadConfirm() {
    if (DatabaseServices.isLocalDatabaseExists()) {
      showTConfirmDialog(
        context,
        contentText: 'Database File ကိုပြန်ပြီး Download ပြုလုပ်ချင်ပါသလား?',
        cancelText: 'မလုပ်ဘူး',
        submitText: 'Download',
        onSubmit: _download,
      );
      return;
    }
    _download();
  }

  void _download() async {
    final dbFile = File(DatabaseServices.getLocalDatabasePath());
    final dbLockFile = File('${DatabaseServices.getLocalDatabasePath()}.lock');
    if (dbFile.existsSync()) {
      await dbFile.delete();
    }
    if (dbLockFile.existsSync()) {
      await dbLockFile.delete();
    }
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TMultiDownloaderDialog(
        manager: DatabaseDownloadManager(),
        urls: [
          'https://github.com/ThanCoder/apyar_app/releases/download/database.v1/apyar.v1.db',
        ],
        onSuccess: () async {
          try {
            await TDB.getInstance().restart();
            if (!mounted) return;
            setState(() {});
            databaseManagerScreenStateNotifier.value =
                !databaseManagerScreenStateNotifier.value;
          } catch (e) {
            if (!context.mounted) return;
            showTMessageDialogError(context, e.toString());
          }
        },
      ),
    );
  }
}

class DatabaseDownloadManager extends TDownloadManagerSimple {
  final client = TClient();
  final token = TClientToken(isCancelFileDelete: true);
  final savePath = DatabaseServices.getLocalDatabasePath();
  @override
  void cancel() {
    token.cancel();
  }

  @override
  Future<void> startWorking(
    StreamController<TProgress> controller,
    List<String> urls,
  ) async {
    controller.add(TProgress.preparing(indexLength: urls.length));

    int index = 0;
    for (var url in urls) {
      index++;
      await client.download(
        url,
        savePath: savePath,
        token: token,
        onCancelCallback: controller.addError,
        onError: controller.addError,
        onReceiveProgressSpeed: (received, total, speed, eta) {
          controller.add(
            TProgress.progress(
              index: index,
              indexLength: urls.length,
              loaded: received,
              total: total,
              message: '${url.getName()} - Downloading....',
            ),
          );
        },
      );
    }

    await controller.close();
  }
}
