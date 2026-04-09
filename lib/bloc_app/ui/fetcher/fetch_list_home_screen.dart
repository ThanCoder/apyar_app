import 'package:apyar_app/bloc_app/ui/fetcher/fetch_item_detail_screen.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetch_item_response_bookmark_toggler.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetcher_services.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetcher_types.dart';
import 'package:apyar_app/components/cache_image.dart';
import 'package:apyar_app/core/extensions/buildcontext_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class FetchListHomeScreen extends StatefulWidget {
  final String url;
  const FetchListHomeScreen({super.key, required this.url});

  @override
  State<FetchListHomeScreen> createState() => _FetchListHomeScreenState();
}

class _FetchListHomeScreenState extends State<FetchListHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init(widget.url));
  }

  FetchListResponse? response;
  bool isLoading = false;
  String? currentUrl;

  Future<void> init(String url, {bool usedCache = true}) async {
    try {
      response = null;
      setState(() {
        isLoading = true;
      });

      response = await FetcherServices.instance.fetchList(
        url,
        hostUrl: widget.url,
        usedCache: usedCache,
      );
      // await Future.delayed(Duration(seconds: 2));
      currentUrl = url;

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
      appBar: AppBar(
        title: Text('Fetch List'),
        actions: [
          if (TPlatform.isDesktop)
            IconButton(
              onPressed: () => init(currentUrl ?? widget.url, usedCache: false),
              icon: Icon(Icons.refresh),
            ),
        ],
      ),
      body: RefreshIndicator.noSpinner(
        onRefresh: () => init(currentUrl ?? widget.url, usedCache: false),
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
                        onPressed: () => init(widget.url),
                        icon: Icon(Icons.refresh),
                      ),
                    ],
                  ),
                ),
              ),
            // result
            if (response != null) _result(),

            if (response != null) _pagiList(),
          ],
        ),
      ),
    );
  }

  Widget _result() {
    return SliverGrid.builder(
      itemCount: response!.items.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisExtent: 220,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemBuilder: (context, index) => _gridItem(response!.items[index]),
    );
  }

  Widget _gridItem(FetchListItem item) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () {
        context.goRoute(
          builder: (context) => FetchItemDetailScreen(item: item),
        );
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: CacheImage(url: item.coverUrl, fit: BoxFit.cover),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
              ),
              child: Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // pagination
  Widget _pagiList() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Wrap(
            spacing: 2,
            runSpacing: 2,
            children: List.generate(
              response!.pagiList.length,
              (index) => _pagiItem(response!.pagiList[index]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pagiItem(FetchListPagiItem item) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () => init(item.url),
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(right: 3),
        decoration: BoxDecoration(
          color: item.active ? Colors.blue : Colors.black,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          item.title,
          style: TextStyle(
            color: item.active ? Colors.white : Colors.blue,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
