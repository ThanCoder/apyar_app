import 'dart:io';

import 'package:apyar_app/app/core/providers/apyar_provider.dart';
import 'package:apyar_app/app/ui/database_manager/add_local_database_list_tile.dart';
import 'package:apyar_app/app/ui/database_manager/database_services.dart';
import 'package:apyar_app/app/ui/database_manager/download_database_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_db/t_db.dart';
import 'package:t_widgets/functions/index.dart';
import 'package:t_widgets/widgets/index.dart';

final databaseManagerScreenStateNotifier = ValueNotifier<bool>(false);

class DatabaseManagerScreen extends StatefulWidget {
  const DatabaseManagerScreen({super.key});

  @override
  State<DatabaseManagerScreen> createState() => _DatabaseManagerScreenState();
}

class _DatabaseManagerScreenState extends State<DatabaseManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Database Manager')),
      body: ValueListenableBuilder(
        valueListenable: databaseManagerScreenStateNotifier,
        builder: (context, value, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: TScrollableColumn(
                  children: [_statusWidget(), Divider(), _actionWiget()],
                ),
              ),
              // button
              Positioned(bottom: 0, right: 0, child: _nextBtn()),
            ],
          );
        },
      ),
    );
  }

  Widget _statusWidget() {
    return ListTile(
      title: Text(
        DatabaseServices.isLocalDatabaseExists()
            ? 'Database မှာ Data ရှိနေပါတယ်'
            : 'Database မရှိပါ',
      ),
      trailing: Icon(
        color: DatabaseServices.isLocalDatabaseExists()
            ? Colors.green
            : Colors.red,
        DatabaseServices.isLocalDatabaseExists()
            ? Icons.check
            : Icons.check_box_outline_blank,
      ),
    );
  }

  Widget _actionWiget() {
    return FutureBuilder(
      future: DatabaseServices.isDatabaseRecordExists(),
      builder: (context, snapshot) {
        return Column(
          children: [
            Text(
              (snapshot.data ?? false)
                  ? 'Database ရှိနေပါတယ်'
                  : 'Database is Empty',
              style: TextStyle(fontSize: 18),
            ),
            DownloadDatabaseListTile(),
            AddLocalDatabaseListTile(),
          ],
        );
      },
    );
  }

  Widget _nextBtn() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 6, 55, 95),
        ),
        onPressed: _readedGetstart,
        child: Text('စတင်အသုံးပြုမယ်', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _readedGetstart() async {
    if (!DatabaseServices.isLocalDatabaseExists()) {
      showTMessageDialogError(
        context,
        'Database မရှိပါ!...\nDatabase ကိုအရင် Download လုပ်ပါ!...',
      );
      return;
    }
    try {
      // remove .lock file
      final file = File('${DatabaseServices.getLocalDatabasePath()}.lock');
      if (file.existsSync()) {
        await file.delete();
      }
      await TDB.getInstance().open(DatabaseServices.getLocalDatabasePath());
      if (!mounted) return;
      await context.read<ApyarProvider>().init(isUsedCache: false);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      showTMessageDialogError(context, e.toString());
    }
  }
}
