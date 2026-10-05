import 'package:apyar_app/core/db/du_db.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:flutter/material.dart';

class DesktopReaderPage extends StatefulWidget {
  const new({super.key, required this.apyar});
  final Apyar apyar;

  @override
  State<DesktopReaderPage> createState() => _DesktopReaderPageState();
}

class _DesktopReaderPageState extends State<DesktopReaderPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  List<String> textList = [];

  void init() async {
    final contentList = await DuDB.instance.apyarContentBox.getAll(
      parentId: widget.apyar.generatedId,
    );
    if (!mounted) return;

    for (var con in contentList) {
      final res = await con.getContent<String>();
      if (!mounted) return;
      if (res.isOk) {
        textList.add('Chapter: ${con.chapter}\n');
        textList.addAll(res.unwrap().split('\n'));
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.apyar.title)),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: .symmetric(vertical: 10, horizontal: 14),
            sliver: SliverList.builder(
              itemCount: textList.length,
              itemBuilder: (context, index) => _item(textList[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(String text) {
    return Text(text, style: TextStyle(fontSize: 20));
  }
}
