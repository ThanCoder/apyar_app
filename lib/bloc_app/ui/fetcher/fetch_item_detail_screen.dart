import 'package:apyar_app/bloc_app/ui/fetcher/fetch_item_response_bookmark_toggler.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetcher_types.dart';
import 'package:apyar_app/components/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

import 'fetcher_services.dart';

class FetchItemDetailScreen extends StatefulWidget {
  final FetchListItem item;
  const FetchItemDetailScreen({super.key, required this.item});

  @override
  State<FetchItemDetailScreen> createState() => _FetchItemDetailScreenState();
}

class _FetchItemDetailScreenState extends State<FetchItemDetailScreen> {
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

  FetchItemResponse? response;
  bool isLoading = false;
  bool isFullScreen = false;

  Future<void> init({bool usedCache = true}) async {
    try {
      setState(() {
        isLoading = true;
      });
      response = null;

      response = await FetcherServices.instance.fetchItemDetail(
        widget.item,
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
              title: Text(widget.item.title),
              actions: [
                if (TPlatform.isDesktop)
                  IconButton(
                    onPressed: () => init(usedCache: false),
                    icon: Icon(Icons.refresh),
                  ),
                if (response != null)
                  FetchItemResponseBookmarkToggler(item: response!),
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
              if (response == null)
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
                )
              else
                SliverList.builder(
                  itemCount: response!.list.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _listItem(response!.list[index]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listItem(FetchItemReturnData item) {
    if (item.type == FetchItemReturnDataType.image) {
      return CacheImage(
        url: item.result,
        // errorWidget: (context, url, error) =>
        //     Center(child: Text('Error: `$url`')),
      );
    }
    return Text(item.result, style: TextStyle(fontSize: 18));
  }
}
