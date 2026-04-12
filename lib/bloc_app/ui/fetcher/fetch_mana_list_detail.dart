import 'package:apyar_app/bloc_app/ui/fetcher/f_website_types.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetcher_types.dart';
import 'package:apyar_app/components/cache_image.dart';
import 'package:apyar_app/core/extensions/buildcontext_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

import 'fetcher_services.dart';

class FetchManaListDetail extends StatefulWidget {
  final FetchManagContentResponseChapterItem item;
  final FWebsite website;
  const FetchManaListDetail({
    super.key,
    required this.item,
    required this.website,
  });

  @override
  State<FetchManaListDetail> createState() => _FetchManaListDetailState();
}

class _FetchManaListDetailState extends State<FetchManaListDetail> {
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

  bool isLoading = false;
  bool isFullScreen = false;
  List<String> images = [];

  Future<void> init({bool usedCache = true}) async {
    try {
      isLoading = true;
      setState(() {});

      images = await FetcherServices.instance.fetchManagaListDetailImages(
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
                'Ch: `${widget.item.title}`',
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

              if (images.isEmpty)
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
              if (images.isNotEmpty)
                SliverList.builder(
                  itemCount: images.length,
                  itemBuilder: (context, index) => _listItem(images[index]),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listItem(String url) {
    //https://express-forward-proxy2.vercel.app
    return CacheImage(url: url);
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
