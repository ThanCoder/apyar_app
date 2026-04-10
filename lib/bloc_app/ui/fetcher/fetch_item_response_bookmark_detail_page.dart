import 'package:apyar_app/bloc_app/cubits/apyar_list_cubit.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetch_item_response_bookmark_toggler.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetcher_types.dart';
import 'package:apyar_app/components/cache_image.dart';
import 'package:apyar_app/core/extensions/buildcontext_extensions.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/models/apyar_content.dart';
import 'package:apyar_app/core/services/apyar_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class FetchItemResponseBookmarkDetailPage extends StatefulWidget {
  final FetchItemResponse item;
  const FetchItemResponseBookmarkDetailPage({super.key, required this.item});

  @override
  State<FetchItemResponseBookmarkDetailPage> createState() =>
      _FetchItemResponseBookmarkDetailPageState();
}

class _FetchItemResponseBookmarkDetailPageState
    extends State<FetchItemResponseBookmarkDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.item.title, style: TextStyle(fontSize: 14)),
        actions: [
          FetchItemResponseBookmarkToggler(item: widget.item),
          IconButton(onPressed: _showMenu, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList.builder(
            itemCount: widget.item.list.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: _listItem(widget.item.list[index]),
            ),
          ),
        ],
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
            ThanPkg.appUtil.copyText(widget.item.item.url);
          },
        ),

        ListTile(
          leading: Icon(Icons.copy_all),
          title: Text('Copy Text Content'),
          onTap: () {
            context.closeNavi();
            ThanPkg.appUtil.copyText(
              widget.item.list.map((e) => e.result).join('\n'),
            );
          },
        ),
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

  void _addLocalDB() async {
    final id = await context.read<ApyarListCubit>().add(
      Apyar(title: widget.item.item.title, date: DateTime.now()),
    );
    if (!mounted) return;
    if (id == -1) {
      showTMessageDialogError(
        context,
        'Database ထဲကို `Apyar` သွင်းလို့မရပါ!။\nError ရှိနေပါတယ်',
      );
      return;
    }
    final contentBuf = StringBuffer();
    for (var item in widget.item.list) {
      if (item.type != FetchItemReturnDataType.text) continue;
      contentBuf.writeln(item.result);
      contentBuf.writeln();
    }
    final contentId = await ApyarServices.instance.addContentByApyarId(
      id,
      ApyarContent(
        apyarId: id,
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
