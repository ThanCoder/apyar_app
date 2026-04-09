import 'dart:async';

import 'package:apyar_app/app/ui/components/apyar_list_item.dart';
import 'package:apyar_app/bloc_app/cubits/apyar_list_cubit.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/app/routes.dart';
import 'package:apyar_app/app/ui/content/content_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_widgets/t_widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  bool isLoading = false;
  bool isSearching = false;
  List<Apyar> apyarList = [];
  List<Apyar> resultList = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    searchController.dispose();
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    super.dispose();
  }

  void init() async {
    apyarList = context.read<ApyarListCubit>().state.list;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: isLoading
          ? Center(child: TLoader.random())
          : CustomScrollView(
              slivers: [_getSearch(), _getSearchingWidget(), _getResultList()],
            ),
    );
  }

  Widget _getSearchingWidget() {
    return SliverToBoxAdapter(
      child: isSearching ? LinearProgressIndicator() : null,
    );
  }

  Widget _getSearch() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      snap: true,
      floating: true,
      pinned: false,
      flexibleSpace: SearchBar(
        controller: searchController,
        // autoFocus: true,
        hintText: 'Search Text...',
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(9),
          ),
        ),
        trailing: [
          IconButton(
            onPressed: () {
              searchController.text = '';
              setState(() {
                isSearching = false;
              });
            },
            icon: Icon(Icons.clear_all),
          ),
        ],
        onChanged: _onSearch,
        onSubmitted: _onSearch,
      ),
    );
  }

  Widget _getResultList() {
    if (searchController.text.isEmpty) {
      return SliverFillRemaining(
        child: Center(child: Text('တစ်ခုခုရေးပါ....')),
      );
    }
    if (!isSearching && resultList.isEmpty) {
      return SliverFillRemaining(child: Center(child: Text('ရှာမတွေ့ပါ....')));
    }
    return SliverList.separated(
      itemCount: resultList.length,
      itemBuilder: (context, index) => _getListItem(resultList[index]),
      separatorBuilder: (context, index) => Divider(),
    );
  }

  Widget _getListItem(Apyar apyar) {
    return ApyarListItem(
      apyar: apyar,
      onClicked: (apyar) =>
          goRoute(context, builder: (context) => ContentScreen(apyar: apyar)),
    );
  }

  void _onSearch(String text) {
    if (text.isEmpty && (_timer?.isActive ?? false)) {
      _timer?.cancel();
      setState(() {
        isSearching = false;
      });
      return;
    }
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    setState(() {
      isSearching = true;
    });
    _timer = Timer(Duration(milliseconds: 1200), _search);
  }

  void _search() async {
    final query = searchController.text;
    resultList = apyarList
        .where((e) => e.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    // Sorting rule
    resultList.sort((a, b) {
      final at = a.title.toLowerCase();
      final bt = b.title.toLowerCase();

      // 1. exact match
      final aExact = at == query;
      final bExact = bt == query;
      if (aExact && !bExact) return -1;
      if (!aExact && bExact) return 1;

      // 2. startsWith
      final aStart = at.startsWith(query);
      final bStart = bt.startsWith(query);
      if (aStart && !bStart) return -1;
      if (!aStart && bStart) return 1;

      // 3. contains (default)
      return at.compareTo(bt);
    });
    if (!mounted) return;
    setState(() {
      isSearching = false;
    });
  }
}
