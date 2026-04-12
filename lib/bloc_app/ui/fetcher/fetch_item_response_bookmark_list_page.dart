import 'package:apyar_app/bloc_app/cubits/fetch_item_response_cubit.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetch_item_response_bookmark_detail_page.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetcher_types.dart';
import 'package:apyar_app/components/cache_image.dart';
import 'package:apyar_app/core/extensions/buildcontext_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_widgets/t_widgets.dart';

class FetchItemResponseBookmarkListPage extends StatefulWidget {
  const FetchItemResponseBookmarkListPage({super.key});

  @override
  State<FetchItemResponseBookmarkListPage> createState() =>
      _FetchItemResponseBookmarkListPageState();
}

class _FetchItemResponseBookmarkListPageState
    extends State<FetchItemResponseBookmarkListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  Future<void> init() async {
    await context.read<FetchItemResponseCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fetch Item Response Bookmark')),
      body: BlocBuilder<FetchItemResponseCubit, FetchItemResponseCubitState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              if (state.isLoading)
                SliverFillRemaining(child: Center(child: TLoaderRandom())),

              if (state.list.isEmpty)
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
                _gridList(state.list),
            ],
          );
        },
      ),
    );
  }

  Widget _gridList(List<FetchItemResponse> list) {
    return SliverGrid.builder(
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisExtent: 220,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      itemBuilder: (context, index) => _gridItem(list[index]),
    );
  }

  Widget _gridItem(FetchItemResponse item) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: () {
        context.goRoute(
          builder: (context) => FetchItemResponseBookmarkDetailPage(item: item),
        );
      },
      onSecondaryTap: () => _showItemMenu(item),
      onLongPress: () => _showItemMenu(item),
      child: Stack(
        children: [
          Positioned.fill(
            child: CacheImage(url: item.item.coverUrl, fit: BoxFit.cover),
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
                item.item.title,
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

  void _showItemMenu(FetchItemResponse item) {
    showTMenuBottomSheet(
      context,
      title: Text('Menu: `${item.item.title}`', style: TextStyle(fontSize: 13)),
      children: [
        ListTile(
          iconColor: Colors.red,
          leading: Icon(Icons.remove_circle),
          title: Text('Remove'),
          onTap: () {
            context.closeNavi();
            context.read<FetchItemResponseCubit>().remove(item);
          },
        ),
      ],
    );
  }
}
