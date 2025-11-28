import 'package:apyar_app/app/core/models/apyar.dart';
import 'package:apyar_app/app/core/models/bookmark.dart';
import 'package:apyar_app/app/core/providers/bookmark_provider.dart';
import 'package:apyar_app/app/routes.dart';
import 'package:apyar_app/app/ui/content/content_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:t_db/t_db.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => false;

  Future<void> init() async {
    context.read<BookmarkProvider>().init(
      onError: (message) {
        if (!mounted) return;
        showTMessageDialogError(context, message);
      },
    );
  }

  BookmarkProvider get getProvider => context.watch<BookmarkProvider>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Mark'),
        actions: [
          !TPlatform.isDesktop
              ? SizedBox.shrink()
              : IconButton(
                  onPressed: context.read<BookmarkProvider>().init,
                  icon: Icon(Icons.refresh),
                ),
        ],
      ),
      body: getProvider.isLoading
          ? Center(child: TLoader.random())
          : RefreshIndicator.adaptive(
              onRefresh: context.read<BookmarkProvider>().init,
              child: ListView.separated(
                itemCount: getProvider.list.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) =>
                    _getListItem(getProvider.list[index]),
              ),
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
      onPressed: () => context.read<BookmarkProvider>().delete(bookmark),
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
