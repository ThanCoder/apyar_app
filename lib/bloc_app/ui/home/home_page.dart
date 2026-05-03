import 'package:apyar_app/app/ui/components/apyar_list_item.dart';
import 'package:apyar_app/bloc_app/cubits/apyar_list_cubit.dart';
import 'package:apyar_app/bloc_app/ui/forms/apyar_edit_form.dart';
import 'package:apyar_app/core/extensions/buildcontext_extensions.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/app/routes.dart';
import 'package:apyar_app/app/ui/content/content_screen.dart';
import 'package:apyar_app/app/ui/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:apyar_app/more_libs/setting/setting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> init({bool isUsedCache = true}) async {
    await context.read<ApyarListCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: _getAppbar(),
      body: BlocBuilder<ApyarListCubit, ApyarListCubitState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: TLoader.random());
          }
          if (state.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          if (state.list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('List Empty!'),
                  IconButton(
                    onPressed: init,
                    icon: Icon(Icons.refresh_sharp, color: Colors.blue),
                  ),
                ],
              ),
            );
          }
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              // _getAppbar(),
              _getSearchBar(),
            ],
            body: RefreshIndicator.adaptive(
              onRefresh: () async => init(isUsedCache: false),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: 10)),
                  _getList(state.list),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _getAppbar() {
    return AppBar(
      title: Text(Setting.instance.appName),
      actions: [
        if (TPlatform.isDesktop)
          IconButton(
            onPressed: () => init(isUsedCache: false),
            icon: Icon(Icons.refresh),
          ),
        IconButton(onPressed: _showSort, icon: Icon(Icons.sort)),
        IconButton(onPressed: _showMainMenu, icon: Icon(Icons.more_vert)),

        // IconButton(onPressed: _onShowMenu, icon: Icon(Icons.more_vert_rounded)),
      ],
    );
  }

  Widget _getSearchBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      snap: true,
      floating: true,
      pinned: false,
      flexibleSpace: SearchBar(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
        ),
        autoFocus: false,
        hintText: 'Search Text...',
        readOnly: true,
        onTap: () => goRoute(context, builder: (context) => SearchScreen()),
      ),
    );
  }

  Widget _getList(List<Apyar> list) {
    return SliverList.separated(
      itemCount: list.length,
      itemBuilder: (context, index) => ApyarListItem(
        apyar: list[index],
        onClicked: (apyar) =>
            goRoute(context, builder: (context) => ContentScreen(apyar: apyar)),
        onRightClicked: _showItemMenu,
      ),
      separatorBuilder: (context, index) => Divider(),
    );
  }

  // sort
  void _showSort() {
    final state = context.read<ApyarListCubit>().state;
    showTSortDialog(
      context,
      isAsc: state.sortAsc,
      sortList: state.sortList,
      currentId: state.sortId,
      sortDialogCallback: (id, isAsc) {
        context.read<ApyarListCubit>().setSort(id, isAsc);
        context.read<ApyarListCubit>().sort();
      },
    );
  }

  void _showMainMenu() {
    showTMenuBottomSheet(
      context,
      children: [
        ListTile(
          leading: Icon(Icons.add),
          title: Text('New Apyar'),
          onTap: () {
            context.closeNavi();
            _showNewApyarDialog();
          },
        ),
      ],
    );
  }

  void _showItemMenu(Apyar apyar) {
    showTMenuBottomSheet(
      context,
      children: [
        ListTile(
          leading: Icon(Icons.edit_document),
          title: Text('Edit'),
          onTap: () {
            context.closeNavi();
            _showEditForm(apyar);
          },
        ),
        ListTile(
          iconColor: Colors.red,
          leading: Icon(Icons.delete),
          title: Text('Delete'),
          onTap: () {
            context.closeNavi();
            _deleteConfirm(apyar);
          },
        ),
      ],
    );
  }

  void _showNewApyarDialog() {
    showTReanmeDialog(
      context,
      text: 'New Untitled',
      submitText: 'New',
      onSubmit: (text) async {
        final apyar = Apyar(title: text, date: DateTime.now());
        final newApyar = await context.read<ApyarListCubit>().add(apyar);
        if (newApyar == null) return;
        _showEditForm(newApyar);
      },
    );
  }

  void _showEditForm(Apyar apyar) {
    context.goRoute(builder: (context) => ApyarEditForm(apyar: apyar));
  }

  void _deleteConfirm(Apyar apyar) {
    showTConfirmDialog(
      context,
      contentText: 'ဖျက်ချင်တာသေချာပြီလား',
      submitText: 'Delete Forever',
      onSubmit: () {
        context.read<ApyarListCubit>().delete(apyar);
      },
    );
  }
}
