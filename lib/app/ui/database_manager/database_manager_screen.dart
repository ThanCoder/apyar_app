import 'package:apyar_app/app/ui/database_manager/add_local_database_list_tile.dart';
import 'package:apyar_app/app/ui/database_manager/database_services.dart';
import 'package:apyar_app/app/ui/database_manager/download_database_list_tile.dart';
import 'package:flutter/material.dart';

import 'package:t_widgets/functions/index.dart';
import 'package:t_widgets/widgets/index.dart';

import 'export_database_list_tile.dart';

class DatabaseManagerScreen extends StatefulWidget {
  const DatabaseManagerScreen({super.key});

  @override
  State<DatabaseManagerScreen> createState() => _DatabaseManagerScreenState();
}

class _DatabaseManagerScreenState extends State<DatabaseManagerScreen> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => init());
    init();
  }

  bool isLoading = false;
  bool existsDB = false;
  Future<void> init() async {
    try {
      setState(() {
        isLoading = true;
        existsDB = false;
      });
      if (DatabaseServices.isLocalDatabaseExists()) {
        existsDB = true;
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showTMessageDialogError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Database Manager')),
      body: isLoading
          ? Center(child: TLoaderRandom())
          : Stack(
              children: [
                Positioned.fill(
                  child: TScrollableColumn(
                    children: [_statusWidget(), Divider(), _actionWiget()],
                  ),
                ),
                // button
                // Positioned(bottom: 0, right: 0, child: _nextBtn()),
              ],
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
        final existsDB = snapshot.data ?? false;
        return Column(
          children: [
            Text(
              existsDB ? 'Database ရှိနေပါတယ်' : 'Database is Empty',
              style: TextStyle(fontSize: 18),
            ),
            DownloadDatabaseListTile(onCheckDB: init),
            AddLocalDatabaseListTile(onCheckDB: init),

            !existsDB
                ? SizedBox.shrink()
                : Card(
                    child: ListTile(
                      iconColor: Colors.red,
                      leading: Icon(Icons.delete),
                      title: Text('Delete DB File'),
                      onTap: _deleteDBFile,
                    ),
                  ),
            !existsDB ? SizedBox.shrink() : Divider(),
            !existsDB ? SizedBox.shrink() : ExportDatabaseListTile(),
          ],
        );
      },
    );
  }

  void _deleteDBFile() {
    showTConfirmDialog(
      context,
      contentText: 'DB File ကိုဖျက်ချင်တာ သေချာပြီလား?',
      submitText: 'Delete Forever',
      onSubmit: () async {
        if (!DatabaseServices.dbFile().existsSync()) return;
        await DatabaseServices.dbFile().delete();
        if (DatabaseServices.dbLockFile().existsSync()) {
          await DatabaseServices.dbLockFile().delete();
        }
        await init();
      },
    );
  }
}
