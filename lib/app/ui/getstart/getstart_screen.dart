import 'package:apyar_app/app/core/db_util.dart';
import 'package:apyar_app/app/ui/getstart/download_database_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/functions/index.dart';
import 'package:t_widgets/widgets/index.dart';
import 'package:than_pkg/t_database/t_recent_db.dart';

class GetstartScreen extends StatefulWidget {
  final Widget onSuccessChild;
  const GetstartScreen({super.key, required this.onSuccessChild});

  @override
  State<GetstartScreen> createState() => _GetstartScreenState();
}

class _GetstartScreenState extends State<GetstartScreen> {
  @override
  Widget build(BuildContext context) {
    final getstartReaded = TRecentDB.getInstance.getBool('getstart-readed');
    if (getstartReaded) {
      return widget.onSuccessChild;
    }
    return Scaffold(
      appBar: AppBar(title: Text('GetStart')),
      body: Stack(
        children: [
          Positioned.fill(
            child: TScrollableColumn(children: [DownloadDatabaseListTile()]),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 6, 55, 95),
                ),
                onPressed: _readedGetstart,
                child: Text('Start', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _readedGetstart() async {
    if (!isLocalDatabaseExists()) {
      showTMessageDialogError(
        context,
        'Database မရှိပါ!...\nDatabase ကိုအရင် Download လုပ်ပါ!...',
      );
      return;
    }
    await TRecentDB.getInstance.putBool('getstart-readed', true);
    if (!mounted) return;
    setState(() {});
  }
}
