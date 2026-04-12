import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/models/apyar_content.dart';
import 'package:apyar_app/core/services/apyar_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_widgets/t_widgets.dart';

class ApyarEditForm extends StatefulWidget {
  final Apyar apyar;
  const ApyarEditForm({super.key, required this.apyar});

  @override
  State<ApyarEditForm> createState() => _ApyarEditFormState();
}

class _ApyarEditFormState extends State<ApyarEditForm> {
  final titleController = TextEditingController();
  final chapterController = TextEditingController();
  final contentController = TextEditingController();

  String? chapterControllerError;

  @override
  void initState() {
    apyar = widget.apyar;
    titleController.text = apyar.title;
    chapterController.text = '1';
    init();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    chapterController.dispose();
    contentController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  bool isContentLoading = false;
  bool isUpdating = false;
  ApyarContent? content;
  late Apyar apyar;
  final _services = ApyarServices.instance;

  void init() async {
    _loadChapterContent();
  }

  void _loadChapterContent() async {
    try {
      content = null;
      contentController.text = '';
      setState(() {
        isContentLoading = true;
      });

      content = await _services.getContentByApyarId(
        widget.apyar.autoId,
        chapter: int.parse(chapterController.text),
      );
      if (!mounted) return;
      setState(() {
        isContentLoading = false;
      });
      if (content != null) {
        contentController.text = content!.body;
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isContentLoading = false;
      });
      showTMessageDialogError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit: ${widget.apyar.title}'),
        actions: [IconButton(onPressed: _saveApyar, icon: Icon(Icons.save_as))],
      ),
      body: isLoading
          ? Center(child: TLoaderRandom())
          : TScrollableColumn(
              children: [
                TTextField(
                  label: Text('Title'),
                  maxLines: 1,
                  controller: titleController,
                ),
                _chapterForm(),
                if (isContentLoading)
                  Center(child: TLoaderRandom())
                else
                  TTextField(
                    label: Text('Content'),
                    maxLines: null,
                    controller: contentController,
                  ),
              ],
            ),
      floatingActionButton: isUpdating
          ? FloatingActionButton(onPressed: null, child: TLoaderRandom())
          : isLoading || isContentLoading || chapterControllerError != null
          ? null
          : FloatingActionButton(onPressed: _save, child: Icon(Icons.save_as)),
    );
  }

  Widget _chapterForm() {
    return Row(
      spacing: 6,
      children: [
        Expanded(
          child: TTextField(
            label: Text('Chapter'),
            maxLines: 1,
            controller: chapterController,
            errorText: chapterControllerError,
            textInputType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              try {
                if (value.isEmpty) {
                  throw Exception('Required Number');
                }
                final ch = int.parse(value);
                if (ch == 0) {
                  throw Exception('Chapter Number အနည်းဆုံး  `1` ဖြစ်ရမယ်');
                }

                chapterControllerError = null;
              } catch (e) {
                chapterControllerError = e.toString();
              }
              setState(() {});
            },
          ),
        ),
        if (chapterControllerError == null)
          IconButton(
            color: Colors.red,
            onPressed: () {
              if (isUpdating || isLoading) return;
              if (chapterControllerError != null) return;
              final ch = int.parse(chapterController.text);
              if (ch == 1) return;
              chapterController.text = (ch - 1).toString();
              _loadChapterContent();
            },
            icon: Icon(Icons.remove_circle),
          ),
        if (chapterControllerError == null)
          IconButton(
            color: Colors.green,
            onPressed: () {
              if (isUpdating || isLoading) return;
              if (chapterControllerError != null) return;
              final ch = int.parse(chapterController.text) + 1;
              chapterController.text = ch.toString();
              _loadChapterContent();
            },
            icon: Icon(Icons.add_circle),
          ),
      ],
    );
  }

  void _save() async {
    try {
      setState(() {
        isUpdating = true;
      });
      late ApyarContent newContent;
      if (content != null) {
        newContent = content!.copyWith(
          chapter: int.parse(chapterController.text),
          body: contentController.text,
        );
      } else {
        newContent = ApyarContent(
          apyarId: widget.apyar.autoId,
          chapter: int.parse(chapterController.text),
          body: contentController.text,
          date: DateTime.now(),
        );
      }

      await _services.setContentByApyarId(widget.apyar.autoId, newContent);

      if (!mounted) return;
      setState(() {
        isUpdating = false;
      });
      chapterController.text = (int.parse(chapterController.text) + 1)
          .toString();
      _loadChapterContent();

      showTSnackBar(context, 'Content Updated');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isUpdating = false;
      });
      showTMessageDialogError(context, e.toString());
    }
  }

  void _saveApyar() async {
    try {
      setState(() {
        isLoading = true;
      });
      apyar = apyar.copyWith(title: titleController.text, date: DateTime.now());
      await _services.updateById(apyar.autoId, apyar);

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
}
