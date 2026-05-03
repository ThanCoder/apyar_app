import 'dart:async';

import 'package:apyar_app/core/interfaces/db/database_interface.dart';
import 'package:apyar_app/core/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:t_client/t_client.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class DownloadDatabaseListTile extends StatefulWidget {
  final void Function() onCheckDB;
  const DownloadDatabaseListTile({super.key, required this.onCheckDB});

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

  String _getDBUrl() {
    if (DatabaseInterface.getDBType() == ApyarDBType.smdb) {
      return 'https://github.com/ThanCoder/apyar_app/releases/download/smdb.db/apyar.apyd.db';
    }
    return 'https://github.com/ThanCoder/apyar_app/releases/download/database.v1/apyar.v1.db';
  }

  void _download() async {
    await DatabaseServices.deleteAllDB();

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TMultiDownloaderDialog(
        manager: DatabaseDownloadManager(),
        urls: [_getDBUrl()],
        onSuccess: widget.onCheckDB,
        onError: (message) => widget.onCheckDB(),
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
