import 'package:apyar_app/bloc_app/cubits/apyar_list_cubit.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/f_website_types.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetch_item_response_bookmark_toggler.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetcher_types.dart';
import 'package:apyar_app/components/cache_image.dart';
import 'package:apyar_app/core/extensions/buildcontext_extensions.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/models/apyar_content.dart';
import 'package:apyar_app/core/services/apyar_services.dart';
import 'package:apyar_app/more_libs/setting/core/rabbit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

import 'fetcher_services.dart';

class FetchItemDetailScreen extends StatefulWidget {
  final FetchListItem item;
  final FWebsite website;
  const FetchItemDetailScreen({
    super.key,
    required this.item,
    required this.website,
  });

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
  final List<FetchItemReturnData> convertList = [];

  Future<void> init({bool usedCache = true}) async {
    try {
      response = null;
      isLoading = true;
      convertList.clear();
      setState(() {});

      response = await FetcherServices.instance.fetchItemDetail(
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
              title: Text(widget.item.title),
              actions: [
                if (TPlatform.isDesktop)
                  IconButton(
                    onPressed: () => init(usedCache: false),
                    icon: Icon(Icons.refresh),
                  ),
                if (response != null)
                  FetchItemResponseBookmarkToggler(item: response!),

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

              if (response != null && response!.list.isEmpty)
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
              if (response != null)
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
        if (response != null)
          ListTile(
            leading: Icon(Icons.copy_all),
            title: Text('Copy Text Content'),
            onTap: () {
              context.closeNavi();
              ThanPkg.appUtil.copyText(
                response!.list.map((e) => e.result).join('\n'),
              );
            },
          ),
        if (response != null)
          ListTile(
            leading: Icon(Icons.font_download_outlined),
            title: Text('Convert Zawgyi Font'),
            onTap: () {
              context.closeNavi();
              _convertFont(false);
            },
          ),
        if (response != null)
          ListTile(
            leading: Icon(Icons.font_download_outlined),
            title: Text('Convert Pyidaungsu Font'),
            onTap: () {
              context.closeNavi();
              _convertFont(true);
            },
          ),
        if (convertList.isNotEmpty)
          ListTile(
            leading: Icon(Icons.font_download_outlined),
            title: Text('Convert Orginal Font'),
            onTap: () {
              context.closeNavi();
              response = response!.copyWith(list: List.of(convertList));
              convertList.clear();
              setState(() {});
            },
          ),
        if (response != null)
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Local Database'),
            onTap: () {
              context.closeNavi();
              _addLocalDB();
            },
          ),
      ],
    );
  }

  void _convertFont(bool isPyidaungsuFont) {
    if (convertList.isEmpty) {
      convertList.addAll(response!.list);
    }
    final list = convertList.map((e) {
      if (e.type == FetchItemReturnDataType.text) {
        return e.copyWith(
          result: isPyidaungsuFont
              ? Rabbit.zg2uni(e.result)
              : Rabbit.uni2zg(e.result),
        );
      }
      return e;
    }).toList();
    response = response!.copyWith(list: list);
    setState(() {});
  }

  void _addLocalDB() async {
    final list = response!.list;
    final title = widget.item.title;

    final newApyar = await context.read<ApyarListCubit>().add(
      Apyar(title: title, date: DateTime.now()),
    );
    if (!mounted) return;
    if (newApyar == null) {
      showTMessageDialogError(
        context,
        'Database ထဲကို `Apyar` သွင်းလို့မရပါ!။\nError ရှိနေပါတယ်',
      );
      return;
    }
    final contentBuf = StringBuffer();
    for (var item in list) {
      if (item.type != FetchItemReturnDataType.text) continue;
      contentBuf.writeln(item.result);
      contentBuf.writeln();
    }
    final contentId = await ApyarServices.instance.addContentByApyarId(
      newApyar.autoId,
      ApyarContent(
        apyarId: newApyar.autoId,
        chapter: 1,
        body: contentBuf.toString(),
        date: DateTime.now(),
      ),
    );
    if (!mounted) return;
    if (contentId == -1) {
      showTMessageDialogError(
        context,
        'Database ထဲကို `ApyarContent` သွင်းလို့မရပါ!။\nError ရှိနေပါတယ်',
      );
      return;
    }

    // success
    showTSnackBar(context, 'Database ထဲကို သွင်းပြီးပါပြီ');
  }
}
