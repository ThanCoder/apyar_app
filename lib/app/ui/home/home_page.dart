import 'package:apyar_app/app/core/models/apyar.dart';
import 'package:apyar_app/app/routes.dart';
import 'package:apyar_app/app/ui/components/bookmark_toggle_widget.dart';
import 'package:apyar_app/app/ui/content/content_screen.dart';
import 'package:apyar_app/app/ui/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:apyar_app/more_libs/setting/setting.dart';
import 'package:t_db/t_db.dart';
import 'package:t_widgets/functions/index.dart';
import 'package:t_widgets/widgets/t_loader.dart';

final _box = TDB.getInstance().getBox<Apyar>();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  bool isLoading = false;
  List<Apyar> list = [];

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
    return Scaffold(
      appBar: AppBar(title: Text(Setting.instance.appName)),
      body: isLoading
          ? Center(child: TLoader.random())
          : CustomScrollView(
              slivers: [
                _getSearchBar(),
                SliverToBoxAdapter(child: SizedBox(height: 10)),
                _getList(),
              ],
            ),
    );
  }

  Widget _getSearchBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      snap: true,
      floating: true,
      pinned: false,
      flexibleSpace: SearchBar(
        autoFocus: false,
        hintText: 'Search...',
        readOnly: true,
        onTap: () => goRoute(context, builder: (context) => SearchScreen()),
      ),
    );
  }

  Widget _getList() {
    return SliverList.separated(
      itemCount: list.length,
      itemBuilder: (context, index) => _getListItem(list[index]),
      separatorBuilder: (context, index) => Divider(),
    );
  }

  Widget _getListItem(Apyar apyar) {
    return ListTile(
      title: Text(apyar.title),
      trailing: BookmarkToggleWidget(apyar: apyar),
      onTap: () =>
          goRoute(context, builder: (context) => ContentScreen(apyar: apyar)),
    );
  }
}
