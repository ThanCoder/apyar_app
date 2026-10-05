import 'dart:async';

import 'package:apyar_app/core/controllers/apyar/apyar_controller.dart';
import 'package:apyar_app/core/controllers/i_controller.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/platforms/pages/fav/fav_toggle_btn.dart';
import 'package:apyar_app/routes.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class DesktopHomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  @override
  void initState() {
    init();
    super.initState();
  }

  final con = ControllerManager.read<ApyarController>();

  Future<void> init({bool force = false}) async {
    if (!force && con.list.isNotEmpty) return;
    await con.fetchApyarList();
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: RefreshIndicator.adaptive(
        onRefresh: () => init(force: true),
        child: StreamBuilder(
          stream: con.events.whereType<ApLoad>(),
          builder: (context, asyncSnapshot) {
            return CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                if (con.isLoading)
                  SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  ),
                if (con.list.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: .symmetric(vertical: 5, horizontal: 10),
                      child: _header(),
                    ),
                  ),
                if (con.list.isEmpty)
                  SliverFillRemaining(
                    child: RefreshButton(text: Text('List Empty'), onClicked: init),
                  )
                else
                  SliverPadding(
                    padding: .symmetric(vertical: 5, horizontal: 10),
                    sliver: SliverList.separated(
                      separatorBuilder: (context, index) => SizedBox(height: 5),
                      itemCount: con.list.length,
                      itemBuilder: (context, index) {
                        final item = con.list[index];
                        return _listItem(item);
                      },
                    ),
                  ),
              ],
            );
          }
        ),
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: Text('Apyar Doc'),
      actions: [
        if (TPlatform.isDesktop)
          IconButton(
            onPressed: () => init(force: true),
            icon: Icon(Icons.refresh_outlined),
          ),
      ],
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
            con.list.length.toString(),
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
      leading: FavToggleBtn(apyar: apyar),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        color: col.onSurfaceVariant,
      ),
      onTap: () async {
        currentId = apyar.generatedId;
        await goContentPage(context, apyar);
        setState(() {});
      },
    );
  }
}
