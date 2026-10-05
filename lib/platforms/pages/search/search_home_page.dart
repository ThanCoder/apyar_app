import 'dart:async';

import 'package:apyar_app/core/controllers/apyar/apyar_controller.dart';
import 'package:apyar_app/core/controllers/i_controller.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/platforms/pages/fav/fav_toggle_btn.dart';
import 'package:apyar_app/routes.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';

class SearchHomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<SearchHomePage> createState() => _SearchHomePageState();
}

class _SearchHomePageState extends State<SearchHomePage> {
  final con = ControllerManager.read<ApyarController>();
  final controller = TextEditingController();
  final focus = FocusNode();

  @override
  dispose() {
    super.dispose();
    controller.dispose();
    focus.dispose();
  }

  List<Apyar> result = [];
  Timer? _timer;
  bool isSearching = false;
  void onChanged(String val) {
    if (val.isEmpty && isSearching) {
      setState(() {
        isSearching = false;
      });
    }
    if (!isSearching) {
      setState(() {
        isSearching = true;
      });
    }
    _timer?.cancel();
    _timer = Timer(Duration(seconds: 1), () => onSearch(val));
  }

  void onSearch(String val) {
    if (val.isEmpty) {
      result = [];
      setState(() {
        isSearching = false;
      });
      return;
    }
    // search
    final up = val.upper;
    result = con.list.where((e) {
      final tp = e.title.upper;
      if (tp.contains(up)) return true;
      return false;
    }).toList();

    setState(() {
      isSearching = false;
    });
  }

  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: .symmetric(vertical: 10, horizontal: 12),
            sliver: SliverList.list(
              children: [
                _search(),
                SizedBox(height: 5),
                Divider(),
                if (isSearching) LinearProgressIndicator(),
                if (isSearching) SizedBox(height: 15),
              ],
            ),
          ),
          // result
          SliverPadding(
            padding: .symmetric(vertical: 10, horizontal: 12),
            sliver: _result,
          ),
        ],
      ),
    );
  }

  SearchBar _search() {
    return SearchBar(
      hintText: 'Search....',
      onChanged: onChanged,
      controller: controller,
      focusNode: focus,
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: .circular(14)),
      ),
      trailing: [
        if (controller.text.isNotEmpty)
          IconButton(
            onPressed: () {
              controller.text = '';
              focus.unfocus();
              result.clear();
              setState(() {
                isSearching = false;
              });
            },
            icon: Icon(Icons.clear_all_outlined),
          ),
      ],
    );
  }

  Widget get _result {
    if (controller.text.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Container(
            padding: .symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: col.surfaceContainer,
              borderRadius: .circular(14),
            ),
            child: Text(
              'Search Someting?....',
              style: TextStyle(
                fontSize: 18,
                fontWeight: .w700,
                color: col.onSurface,
              ),
            ),
          ),
        ),
      );
    }
    if (result.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Container(
            padding: .symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: col.surfaceContainer,
              borderRadius: .circular(14),
            ),
            child: Text(
              'Not Found!?....',
              style: TextStyle(
                fontSize: 18,
                fontWeight: .w700,
                color: col.onSurface,
              ),
            ),
          ),
        ),
      );
    }
    return SliverList.separated(
      separatorBuilder: (context, index) => SizedBox(height: 5),
      itemCount: result.length,
      itemBuilder: (context, index) => _listItem(result[index]),
    );
  }

  Widget _listItem(Apyar apyar) {
    return ListTile(
      tileColor: col.surfaceContainer,
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
        await goContentPage(context, apyar);
        setState(() {});
      },
    );
  }
}
