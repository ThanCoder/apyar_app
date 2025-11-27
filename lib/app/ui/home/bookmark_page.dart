import 'package:apyar_app/app/core/models/apyar.dart';
import 'package:apyar_app/app/core/models/bookmark.dart';
import 'package:apyar_app/app/routes.dart';
import 'package:apyar_app/app/ui/content/content_screen.dart';
import 'package:flutter/material.dart';
import 'package:t_db/t_db.dart';
import 'package:t_widgets/t_widgets.dart';

final _box = TDB.getInstance().getBox<Bookmark>();
final _apyarBox = TDB.getInstance().getBox<Apyar>();

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  bool get wantKeepAlive => false;

  bool isLoading = false;
  List<Bookmark> list = [];
  Future<void> init() async {
    try {
      setState(() {
        isLoading = true;
      });
      list = await _box.getAll();
      if (!mounted) return;
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
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text('Book Mark')),
      body: isLoading
          ? Center(child: TLoader.random())
          : ListView.separated(
              itemCount: list.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) => _getListItem(list[index]),
            ),
    );
  }

  Widget _getListItem(Bookmark bookmark) {
    return ListTile(
      title: Text(bookmark.title),
      trailing: _getBookmarkRemoveWidget(bookmark),
      onTap: () => _goApyarContent(bookmark),
      // ,
    );
  }

  Widget _getBookmarkRemoveWidget(Bookmark bookmark) {
    return IconButton(
      onPressed: () async {
        final index = list.indexWhere((e) => e.autoId == bookmark.autoId);
        if (index == -1) return;
        list.removeAt(index);
        await _box.deleteById(bookmark.autoId);
        if (!mounted) return;
        setState(() {});
      },
      icon: Icon(color: Colors.red, Icons.bookmark_remove),
    );
  }

  void _goApyarContent(Bookmark bookmark) async {
    final apyar = await _apyarBox.getById(bookmark.apyarId);
    if (!mounted) return;
    if (apyar == null) {
      showTMessageDialogError(context, 'apyar not found!');
    }
    goRoute(context, builder: (context) => ContentScreen(apyar: apyar!));
  }
}
