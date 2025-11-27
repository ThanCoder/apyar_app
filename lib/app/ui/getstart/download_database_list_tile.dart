import 'dart:async';
import 'dart:io';

import 'package:apyar_app/app/core/db_util.dart';
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
          'Database ကို Download ${isLocalDatabaseExists() ? 'လုပ်ထားပြီးပါပြီ' : 'လုပ်ရပါမယ်'}',
        ),
        trailing: Icon(
          color: isExistsDB ? Colors.green : Colors.red,
          isExistsDB ? Icons.check : Icons.check_box_outline_blank,
        ),
        onTap: _downloadConfirm,
      ),
    );
  }

  bool get isExistsDB {
    return isLocalDatabaseExists();
  }

  void _downloadConfirm() {
    if (isLocalDatabaseExists()) {
      showTConfirmDialog(
        context,
        contentText: 'Databas ကိုပြန်ပြီး Download ပြုလုပ်ချင်ပါသလား?',
        cancelText: 'မလုပ်ဘူး',
        submitText: 'Download',
        onSubmit: _download,
      );
      return;
    }
    _download();
  }

  void _download() async {
    final dbFile = File(getLocalDatabasePath());
    final dbLockFile = File('${getLocalDatabasePath()}.lock');
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
          await TDB.getInstance().restart();
          if (!mounted) return;
          setState(() {});
        },
      ),
    );
  }
}

class DatabaseDownloadManager extends TDownloadManagerSimple {
  final client = TClient();
  final token = TClientToken(isCancelFileDelete: false);
  final savePath = getLocalDatabasePath();
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
