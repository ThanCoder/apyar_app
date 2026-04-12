import 'package:apyar_app/app/routes.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/f_website_types.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetch_mana_list_detail.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetcher_types.dart';
import 'package:apyar_app/components/cache_image.dart';
import 'package:apyar_app/core/extensions/buildcontext_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

import 'fetcher_services.dart';

class FetchManaContentScreen extends StatefulWidget {
  final FetchListItem item;
  final FWebsite website;
  const FetchManaContentScreen({
    super.key,
    required this.item,
    required this.website,
  });

  @override
  State<FetchManaContentScreen> createState() => _FetchManaContentScreenState();
}

class _FetchManaContentScreenState extends State<FetchManaContentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  void dispose() {
    ThanPkg.platform.toggleFullScreen(isFullScreen: false);
    super.dispose();
  }

  FetchManagContentResponse? response;
  bool isLoading = false;
  bool isFullScreen = false;
  final List<FetchItemReturnData> convertList = [];

  Future<void> init({bool usedCache = true}) async {
    try {
      response = null;
      isLoading = true;
      convertList.clear();
      setState(() {});

      response = await FetcherServices.instance.fetchManagaContent(
        widget.item,
        website: widget.website,
        usedCache: usedCache,
      );

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
      appBar: isFullScreen
          ? null
          : AppBar(
              title: Text(
                'Manga: `${widget.item.title}`',
                style: TextStyle(fontSize: 15),
              ),
              actions: [
                if (TPlatform.isDesktop)
                  IconButton(
                    onPressed: () => init(usedCache: false),
                    icon: Icon(Icons.refresh),
                  ),

                // if (response != null)
                //   FetchItemResponseBookmarkToggler(item: response!),
                IconButton(onPressed: _showMenu, icon: Icon(Icons.more_vert)),
              ],
            ),
      body: RefreshIndicator.noSpinner(
        onRefresh: () => init(usedCache: false),
        child: GestureDetector(
          onDoubleTap: () {
            isFullScreen = !isFullScreen;
            ThanPkg.platform.toggleFullScreen(isFullScreen: isFullScreen);
            setState(() {});
          },
          child: CustomScrollView(
            slivers: [
              if (isLoading)
                SliverFillRemaining(child: Center(child: TLoaderRandom())),

              if (response != null && response!.items.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('List Empty'),
                        IconButton(
                          onPressed: () => init(),
                          icon: Icon(Icons.refresh),
                        ),
                      ],
                    ),
                  ),
                ),
              if (response != null) _content(),
              if (response != null)
                SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 120,
                    mainAxisExtent: 60,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: response!.items.length,
                  itemBuilder: (context, index) =>
                      _listItem(response!.items[index]),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 3,
          children: [
            Text(
              response!.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            CacheImage(url: response!.coverUrl),
            Text(response!.content),
          ],
        ),
      ),
    );
  }

  Widget _listItem(FetchManagContentResponseChapterItem item) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () => goRoute(
        context,
        builder: (context) =>
            FetchManaListDetail(item: item, website: widget.website),
      ),
      child: Card(
        color: Colors.pink,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(item.title, style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  void _showMenu() {
    showTMenuBottomSheet(
      context,
      children: [
        ListTile(
          leading: Icon(Icons.copy),
          title: Text('Copy Web Url'),
          onTap: () {
            context.closeNavi();
            ThanPkg.appUtil.copyText(widget.item.url);
          },
        ),
      ],
    );
  }
}
