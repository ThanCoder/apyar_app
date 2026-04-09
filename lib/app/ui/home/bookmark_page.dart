import 'package:apyar_app/app/ui/components/apyar_list_item.dart';
import 'package:apyar_app/app/ui/content/content_screen.dart';
import 'package:apyar_app/bloc_app/cubits/apyar_bookmark_list_cubit.dart';
import 'package:apyar_app/core/extensions/buildcontext_extensions.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  bool get wantKeepAlive => false;

  Future<void> init() async {
    await context.read<ApyarBookmarkListCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Mark'),
        actions: [
          !TPlatform.isDesktop
              ? SizedBox.shrink()
              : IconButton(onPressed: init, icon: Icon(Icons.refresh)),
        ],
      ),
      body: BlocBuilder<ApyarBookmarkListCubit, ApyarBookmarkListCubitState>(
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
          return RefreshIndicator.adaptive(
            onRefresh: init,
            child: ListView.separated(
              itemCount: state.list.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) => _getListItem(state.list[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _getListItem(Apyar apyar) {
    return ApyarListItem(
      apyar: apyar,
      onClicked: (apyar) =>
          context.goRoute(builder: (context) => ContentScreen(apyar: apyar)),
    );
  }
}
