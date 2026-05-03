import 'package:apyar_app/core/extensions/buildcontext_extensions.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/models/apyar_content.dart';
import 'package:apyar_app/app/ui/components/bookmark_toggle_widget.dart';
import 'package:apyar_app/core/services/apyar_services.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  @override
  void dispose() {
    ThanPkg.platform.toggleFullScreen(isFullScreen: false);
    ThanPkg.platform.toggleKeepScreen(isKeep: false);
    scrollController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  bool isFullscreen = false;
  List<ApyarContent> allContentList = [];
  List<ApyarContent> contentList = [];
  List<String> textList = [];
  int showContentListIndex = 0;
  int fontSize = 18;

  final scrollController = ScrollController();

  void init() async {
    ThanPkg.platform.toggleKeepScreen(isKeep: true);
    await _loadChapterContent();
    _initSettingConfig();
  }

  void _initSettingConfig() {
    fontSize = TRecentDB.getInstance.getInt('apyar_content_font_size', def: 18);
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _loadChapterContent() async {
    try {
      ThanPkg.platform.toggleKeepScreen(isKeep: true);
      showContentListIndex = 0;
      setState(() {
        isLoading = true;
      });
      allContentList = await ApyarServices.instance.getContentDB().getAll(
        parentId: widget.apyar.autoId,
      );
      allContentList.sort((a, b) => a.chapter.compareTo(b.chapter));
      if (allContentList.isNotEmpty) {
        contentList.add(allContentList.first);
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
      body: GestureDetector(
        onDoubleTap: _toggleFullscreen,
        onLongPress: _showMenu,
        onSecondaryTap: _showMenu,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [_getAppbar(), _getContent(), _showNextBtn()],
        ),
      ),
    );
  }

  Widget _getAppbar() {
    if (isFullscreen) {
      return SliverToBoxAdapter();
    }
    return SliverAppBar(
      title: Text(widget.apyar.title, style: TextStyle(fontSize: 14)),
      snap: true,
      floating: true,
      pinned: false,
      actions: [BookmarkToggleWidget(apyar: widget.apyar)],
    );
  }

  Widget _getContent() {
    if (isLoading) {
      return SliverFillRemaining(child: Center(child: TLoader.random()));
    }
    if (contentList.isEmpty) {
      return SliverFillRemaining(
        child: Center(child: Text('Content မရှိပါ!...')),
      );
    }
    return SliverList.builder(
      itemCount: contentList.length,
      itemBuilder: (context, index) => _listItem(contentList[index]),
    );
  }

  Widget _listItem(ApyarContent content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chapter: `${content.chapter}`',
            style: TextStyle(
              fontSize: fontSize.toDouble(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(),
          SizedBox(height: 10),
          Text(content.body, style: TextStyle(fontSize: fontSize.toDouble())),
        ],
      ),
    );
  }

  Widget _showNextBtn() {
    return SliverToBoxAdapter(
      child: (showContentListIndex + 1) > allContentList.length - 1
          ? null
          : InkWell(
              onTap: () {
                showContentListIndex++;
                final next = allContentList[showContentListIndex];
                contentList.add(next);
                setState(() {});
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        'Next Chapter: `${allContentList[showContentListIndex].chapter + 1}`',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Center(child: Icon(Icons.next_plan)),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _toggleFullscreen() {
    isFullscreen = !isFullscreen;
    ThanPkg.platform.toggleFullScreen(isFullScreen: isFullscreen);
    setState(() {});
  }

  void _showMenu() {
    showTMenuBottomSheetSingle(
      context,
      title: Text('Setting'),
      child: _MainMenu(onDone: _initSettingConfig),
    );
  }
}

class _MainMenu extends StatefulWidget {
  final void Function() onDone;
  const _MainMenu({required this.onDone});

  @override
  State<_MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<_MainMenu> {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    fontController.dispose();
    super.dispose();
  }

  final fontController = TextEditingController();
  void init() {
    fontController.text = TRecentDB.getInstance
        .getInt('apyar_content_font_size', def: 18)
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TScrollableColumn(
        children: [
          TNumberField(
            label: Text('Font Size'),
            maxLines: 1,
            controller: fontController,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [TextButton(onPressed: _save, child: Text('သိမ်းမယ်'))],
          ),
        ],
      ),
    );
  }

  void _save() async {
    try {
      await TRecentDB.getInstance.putInt(
        'apyar_content_font_size',
        int.parse(fontController.text),
      );

      if (!mounted) return;
      context.closeNavi();
      widget.onDone();
    } catch (e) {
      if (!mounted) return;
      showTMessageDialogError(context, e.toString());
    }
  }
}
