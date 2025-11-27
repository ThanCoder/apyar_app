import 'package:apyar_app/app/core/models/apyar.dart';
import 'package:apyar_app/app/core/models/apyar_content.dart';
import 'package:apyar_app/app/ui/components/bookmark_toggle_widget.dart';
import 'package:flutter/material.dart';
import 'package:t_db/t_db.dart';
import 'package:t_widgets/functions/message_func.dart';
import 'package:t_widgets/widgets/index.dart';
import 'package:than_pkg/than_pkg.dart';

final _box = TDB.getInstance().getBox<ApyarContent>();

class ContentScreen extends StatefulWidget {
  final Apyar apyar;
  const ContentScreen({super.key, required this.apyar});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    ThanPkg.platform.toggleFullScreen(isFullScreen: false);
    super.dispose();
  }

  bool isLoading = false;
  bool isFullscreen = false;
  ApyarContent? content;
  List<String> textList = [];

  void init() async {
    try {
      setState(() {
        isLoading = true;
      });
      content = await _box.getOne(
        (value) => value.apyarId == widget.apyar.autoId,
      );
      if (content != null) {
        textList.addAll(content!.body.split('\n\n'));
      }

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
      body: isLoading
          ? Center(child: TLoader.random())
          : GestureDetector(
              onDoubleTap: _toggleFullscreen,
              child: CustomScrollView(slivers: [_getAppbar(), _getContent()]),
            ),
    );
  }

  Widget _getAppbar() {
    if (isFullscreen) {
      return SliverToBoxAdapter();
    }
    return SliverAppBar(
      title: Text(widget.apyar.title),
      snap: true,
      floating: true,
      pinned: false,
      actions: [BookmarkToggleWidget(apyar: widget.apyar)],
    );
  }

  Widget _getContent() {
    if (content == null) {
      return SliverFillRemaining(
        child: Center(child: Text('Content မရှိပါ!...')),
      );
    }
    return _getTextList();
  }

  Widget _getTextList() {
    return SliverList.builder(
      itemCount: textList.length,
      itemBuilder: (context, index) {
        final text = textList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(text, style: TextStyle(fontSize: 18)),
        );
      },
    );
  }

  void _toggleFullscreen() {
    isFullscreen = !isFullscreen;
    ThanPkg.platform.toggleFullScreen(isFullScreen: isFullscreen);
    setState(() {});
  }
}
