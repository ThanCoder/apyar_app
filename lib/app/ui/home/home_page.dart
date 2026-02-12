import 'package:apyar_app/app/core/models/apyar.dart';
import 'package:apyar_app/app/core/providers/apyar_provider.dart';
import 'package:apyar_app/app/routes.dart';
import 'package:apyar_app/app/ui/components/bookmark_toggle_widget.dart';
import 'package:apyar_app/app/ui/content/content_screen.dart';
import 'package:apyar_app/app/ui/database_manager/database_manager_screen.dart';
import 'package:apyar_app/app/ui/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:apyar_app/more_libs/setting/setting.dart';
import 'package:provider/provider.dart';
import 'package:t_db/t_db.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> init({bool isUsedCache = true}) async {
    if (!TDB.getInstance().isDataRecordCreatedExists) {
      goRoute(context, builder: (context) => DatabaseManagerScreen());
      return;
    }
    context.read<ApyarProvider>().init(
      isUsedCache: isUsedCache,
      onError: (message) {
        if (!mounted) return;
        showTMessageDialogError(context, message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: _getAppbar(),
      body: getWProvider.isLoading
          ? Center(child: TLoader.random())
          : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                // _getAppbar(),
                _getSearchBar(),
              ],
              body: RefreshIndicator.adaptive(
                onRefresh: () async => init(isUsedCache: false),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: SizedBox(height: 10)),
                    _getList(),
                  ],
                ),
              ),
            ),
    );
  }

  ApyarProvider get getWProvider => context.watch<ApyarProvider>();
  ApyarProvider get getRProvider => context.read<ApyarProvider>();

  AppBar _getAppbar() {
    return AppBar(
      title: Text(Setting.instance.appName),
      actions: [
        IconButton(onPressed: _showSort, icon: Icon(Icons.sort)),
        if (!TPlatform.isDesktop)
          SizedBox.shrink()
        else
          IconButton(
            onPressed: () => init(isUsedCache: false),
            icon: Icon(Icons.refresh),
          ),
        // IconButton(onPressed: _onShowMenu, icon: Icon(Icons.more_vert_rounded)),
      ],
    );
  }

  Widget _getSearchBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      snap: true,
      floating: true,
      pinned: false,
      flexibleSpace: SearchBar(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
        ),
        autoFocus: false,
        hintText: 'Search Text...',
        readOnly: true,
        onTap: () => goRoute(context, builder: (context) => SearchScreen()),
      ),
    );
  }

  Widget _getList() {
    return SliverList.separated(
      itemCount: getWProvider.list.length,
      itemBuilder: (context, index) => _getListItem(getWProvider.list[index]),
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

  // sort
  void _showSort() {
    showTSortDialog(
      context,
      isAsc: getRProvider.sortAsc,
      sortList: getRProvider.sortList,
      currentId: getRProvider.sortId,
      sortDialogCallback: getRProvider.setSort,
    );
  }
}
