import 'dart:async';

import 'package:apyar_app/core/db/du_db.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/platforms/pages/desktop_reader_page.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:dual_store/dual_store.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class DesktopHomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = db.store.events.all
        .where(
          (e) => e is AddId || e is ChangePath || e is DeleteId || e is Open,
        )
        .listen((event) {
          init();
        });
    init();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  List<Apyar> list = [];
  bool isLoading = false;
  final db = DuDB.instance;

  Future<void> init() async {
    list.clear();
    setState(() {
      isLoading = true;
    });
    await DuDB.instance.reloadIfNotOpened();
    if (!mounted) return;
    list = await DuDB.instance.apyarBox.getAll();

    setState(() {
      isLoading = false;
    });
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apyar Doc'),
        actions: [
          if (TPlatform.isDesktop)
            IconButton(onPressed: init, icon: Icon(Icons.refresh_outlined)),
        ],
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: init,
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: [
            if (isLoading)
              SliverFillRemaining(
                child: Center(child: CircularProgressIndicator.adaptive()),
              ),
            if (list.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: .symmetric(vertical: 5, horizontal: 10),
                  child: _header(),
                ),
              ),
            if (list.isEmpty)
              SliverFillRemaining(
                child: RefreshButton(text: Text('List Empty'), onClicked: init),
              )
            else
              SliverPadding(
                padding: .symmetric(vertical: 5, horizontal: 10),
                sliver: SliverList.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 5),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return _listItem(item);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _header() => Container(
    padding: .symmetric(vertical: 8, horizontal: 10),
    decoration: BoxDecoration(
      color: col.surfaceContainer,
      borderRadius: .circular(14),
    ),
    child: Row(
      spacing: 10,
      children: [
        Icon(Icons.file_present_outlined),
        Text(
          'Apyar Documents',
          style: TextStyle(
            fontSize: 19,
            color: col.onSurface,
            fontWeight: .w700,
          ),
        ),
        Spacer(),
        Container(
          padding: .symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: col.primaryContainer.withValues(alpha: .45),
            borderRadius: .circular(14),
          ),
          child: Text(
            list.length.toString(),
            style: TextStyle(color: col.onPrimaryContainer, fontWeight: .w700),
          ),
        ),
      ],
    ),
  );

  int? currentId;

  Widget _listItem(Apyar apyar) {
    return ListTile(
      tileColor: currentId == apyar.generatedId
          ? col.primaryContainer
          : col.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      // leading: Icon(Icons.favorite_outline),
      title: Text(
        apyar.title,
        style: TextStyle(color: col.onSurface, fontWeight: .w600, fontSize: 14),
      ),
      leading: IconButton(onPressed: () {}, icon: Icon(Icons.favorite_outline)),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        color: col.onSurfaceVariant,
      ),
      onTap: () async {
        currentId = apyar.generatedId;
        await context.pushMaterialPageRoute(
          builder: (mainCtx) => DesktopReaderPage(apyar: apyar),
        );
        setState(() {});
      },
    );
  }
}
