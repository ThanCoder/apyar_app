import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/models/apyar_content.dart';
import 'package:apyar_app/app/ui/components/bookmark_toggle_widget.dart';
import 'package:apyar_app/core/services/apyar_services.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/functions/message_func.dart';
import 'package:t_widgets/widgets/index.dart';
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
    init();
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

  final scrollController = ScrollController();

  void init() async {
    ThanPkg.platform.toggleKeepScreen(isKeep: true);
    await _loadChapterContent();
  }

  Future<void> _loadChapterContent() async {
    try {
      ThanPkg.platform.toggleKeepScreen(isKeep: true);
      showContentListIndex = 0;
      setState(() {
        isLoading = true;
      });
      allContentList = await ApyarServices.instance.getContentListByApyarId(
        widget.apyar.autoId,
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
    return _getTextList();
  }

  Widget _getTextList() {
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Divider(),
          SizedBox(height: 10),
          Text(content.body, style: TextStyle(fontSize: 18)),
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
}
