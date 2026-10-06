import 'package:apyar_app/core/db/du_db.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/utils/app_util.dart';
import 'package:apyar_app/keys.dart';
import 'package:apyar_app/platforms/components/menu/reader_config_menu.dart';
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

  final cf = AppUtil.instance.config;
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

  void showMenu() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => ReaderConfigMenu(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _appbar(),
      body: StreamBuilder(
        stream: cf.stream.put.where((e) => e.key == textReaderFontSizekey),
        builder: (context, asyncSnapshot) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                snap: true,
                floating: true,
                pinned: false,
                title: Text(widget.apyar.title),
                actions: [
                  IconButton(
                    onPressed: showMenu,
                    icon: Icon(Icons.more_vert_outlined),
                  ),
                ],
              ),
              SliverPadding(
                padding: .symmetric(vertical: 10, horizontal: 14),
                sliver: SliverList.builder(
                  itemCount: textList.length,
                  itemBuilder: (context, index) => _item(textList[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // AppBar _appbar() => AppBar(
  //   title: Text(widget.apyar.title),
  //   actions: [
  //     IconButton(onPressed: showMenu, icon: Icon(Icons.more_vert_outlined)),
  //   ],
  // );

  Widget _item(String text) {
    final fontSize = cf.getDouble(textReaderFontSizekey, 18);
    return Text(text, style: TextStyle(fontSize: fontSize));
  }
}
