import 'dart:io';

import 'package:apyar_app/app/ui/components/apyar_list_item.dart';
import 'package:apyar_app/app/ui/content/content_screen.dart';
import 'package:apyar_app/bloc_app/cubits/apyar_bookmark_list_cubit.dart';
import 'package:apyar_app/core/extensions/buildcontext_extensions.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/services/apyar_bookmark_services.dart';
import 'package:apyar_app/more_libs/setting/core/path_util.dart';
import 'package:file_selector/file_selector.dart';
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
          IconButton(onPressed: _showMenu, icon: Icon(Icons.more_vert)),
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

  void _showMenu() {
    showTMenuBottomSheet(
      context,
      children: [
        ListTile(
          leading: Icon(Icons.import_export),
          title: Text('Import Bookmark File'),
          onTap: () {
            context.closeNavi();
            final dbFile = ApyarBookmarkServices.instance.dbFile;
            if (dbFile.existsSync() && dbFile.readAsStringSync().isNotEmpty) {
              showTConfirmDialog(
                context,
                cancelText: 'မသွင်းတော့ဘူး',
                submitText: 'သွင်းမယ်',
                contentText:
                    'BookMark ရှိနေပါတယ်။\nသင်က သွင်းလိုက်မယ်ဆိုရင် ရှိနေပြီးသား Bookmark တွေပျက်သွားပါမယ်။\nသွင်းချင်ပါသလား?။',
                onSubmit: _importBookmark,
              );
            } else {
              _importBookmark();
            }
          },
        ),
        if (ApyarBookmarkServices.instance.dBFileHasData())
          ListTile(
            leading: Icon(Icons.import_export),
            title: Text('Export Bookmark File'),
            onTap: () {
              context.closeNavi();
              _exportBookmark();
            },
          ),
        if (ApyarBookmarkServices.instance.dBFileHasData())
          ListTile(
            iconColor: Colors.red,
            leading: Icon(Icons.delete),
            title: Text('Delete Bookmark File'),
            onTap: () {
              context.closeNavi();
              _deleteBookmark();
            },
          ),
      ],
    );
  }

  void _importBookmark() async {
    try {
      final res = await openFile(
        initialDirectory: PathUtil.getOutPath(),
        confirmButtonText: 'apyar.bookmark.db',
        acceptedTypeGroups: [
          XTypeGroup(
            extensions: ['json', 'db.json'],
            mimeTypes: ['application/json'],
          ),
        ],
      );
      if (res == null) return;

      final inpStream = File(res.path).openRead();
      final outStream = ApyarBookmarkServices.instance.dbFile.openWrite();
      await inpStream.pipe(outStream);
      await outStream.close();

      if (!mounted) return;
      showTMessageDialog(
        context,
        'Imported Path: ${res.path}',
        title: Text('Bookmark ထည့်သွင်းပြီးပါပြီ'),
      );
      init();
    } catch (e) {
      if (!mounted) return;
      showTMessageDialogError(context, e.toString());
    }
  }

  void _exportBookmark() async {
    try {
      final dbFile = ApyarBookmarkServices.instance.dbFile;
      if (!dbFile.existsSync()) return;
      // for desktop
      if (Platform.isLinux && Platform.isMacOS && Platform.isWindows) {
        final loc = await getSaveLocation(
          initialDirectory: PathUtil.getOutPath(),
          canCreateDirectories: true,
          confirmButtonText: 'Save Bookmark',
          suggestedName: dbFile.getName(),
        );

        if (loc == null) {
          return;
        }
        final inpStream = dbFile.openRead();
        final outStream = File(loc.path).openWrite();
        await inpStream.pipe(outStream);
        await outStream.close();

        if (!mounted) return;
        showTMessageDialog(
          context,
          'Saved Path: ${loc.path}',
          title: Text('Bookmark Saved'),
        );
        return;
      }
      if (Platform.isAndroid) {
        // check permission
        if (!await ThanPkg.android.permission.isStoragePermissionGranted()) {
          await ThanPkg.android.permission.requestStoragePermission();
        }
        final outFile = File(PathUtil.getOutPath(name: dbFile.getName()));
        final inpStream = dbFile.openRead();
        final outStream = outFile.openWrite();
        await inpStream.pipe(outStream);
        await outStream.close();

        if (!mounted) return;
        showTMessageDialog(
          context,
          'Saved Path: ${outFile.path}',
          title: Text('Bookmark Saved'),
        );
        return;
      }
      showTMessageDialogError(
        context,
        'Current OperatingSystem: `${Platform.operatingSystem}` Not Supported~',
      );
    } catch (e) {
      if (!mounted) return;
      showTMessageDialogError(context, e.toString());
    }
  }

  void _deleteBookmark() {
    showTConfirmDialog(
      context,
      cancelText: 'မဖျက်ဘူး',
      submitText: 'ဖျက်မယ်',
      contentText: 'Database ဖျက်ချင်တာ သေချာပြီလား?',
      onSubmit: () async {
        if (ApyarBookmarkServices.instance.dbFile.existsSync()) {
          await ApyarBookmarkServices.instance.dbFile.delete();
        }
        init();
      },
    );
  }
}
