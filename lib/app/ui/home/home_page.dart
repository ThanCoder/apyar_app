import 'package:apyar_app/app/core/models/apyar.dart';
import 'package:apyar_app/app/core/providers/apyar_provider.dart';
import 'package:apyar_app/app/routes.dart';
import 'package:apyar_app/app/ui/components/bookmark_toggle_widget.dart';
import 'package:apyar_app/app/ui/content/content_screen.dart';
import 'package:apyar_app/app/ui/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:apyar_app/more_libs/setting/setting.dart';
import 'package:provider/provider.dart';
import 'package:t_widgets/t_widgets_dev.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => init());
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> init({bool isUsedCache = true}) async {
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
      body: getProvider.isLoading
          ? Center(child: TLoader.random())
          : RefreshIndicator.adaptive(
              onRefresh: () async => init(isUsedCache: false),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  // _getAppbar(),
                  _getSearchBar(),
                ],
                body: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: SizedBox(height: 10)),
                    _getList(),
                  ],
                ),
              ),
            ),
    );
  }

  ApyarProvider get getProvider => context.watch<ApyarProvider>();

  AppBar _getAppbar() {
    return AppBar(
      title: Text(Setting.instance.appName),
      actions: [
        if (!TPlatform.isDesktop)
          SizedBox.shrink()
        else
          IconButton(
            onPressed: () => init(isUsedCache: false),
            icon: Icon(Icons.refresh),
          ),
        IconButton(onPressed: _onShowMenu, icon: Icon(Icons.more_vert_rounded)),
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
      itemCount: getProvider.list.length,
      itemBuilder: (context, index) => _getListItem(getProvider.list[index]),
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

  //menu
  void _onShowMenu() {
    showTMenuBottomSheet(
      context,
      children: [
        ListTile(
          leading: Icon(Icons.sort),
          title: Text('Sort'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.sort),
          title: Text('Random Sort'),
          onTap: () {
            Navigator.pop(context);
            context.read<ApyarProvider>().sortRandom();
          },
        ),
      ],
    );
  }
}
