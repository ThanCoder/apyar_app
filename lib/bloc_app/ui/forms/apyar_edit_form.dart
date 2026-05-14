import 'package:apyar_app/bloc_app/cubits/apyar_list_cubit.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/models/content.dart';
import 'package:apyar_app/core/services/apyar_services.dart';
import 'package:apyar_app/core/services/dual_store_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late Apyar apyar;
  late DualStoreServices store;

  void init() async {
    store = await ApyarServices.instance.getDualStore();
    _loadChapterContent();
  }

  void _loadChapterContent() async {
    try {
      contentController.text = '';
      setState(() {
        isContentLoading = true;
      });
      final content = await store.contentBox.getOne(
        (value) =>
            value.apyarId == widget.apyar.id &&
            value.chapter == (int.tryParse(chapterController.text) ?? 1),
      );
      if (content != null) {
        final bigString = await store.contentBox.readBigDataAsString(content);
        contentController.text = bigString ?? '';
      }
      if (!mounted) return;
      setState(() {
        isContentLoading = false;
      });
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
        actions: [
          IconButton(onPressed: _updateApyar, icon: Icon(Icons.save_as)),
        ],
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
      final content = await store.contentBox.getOne(
        (value) =>
            value.apyarId == widget.apyar.id &&
            value.chapter == (int.tryParse(chapterController.text) ?? 1),
      );
      if (content == null) {
        await store.contentBox.addWithBigDataString(
          Content(
            apyarId: widget.apyar.id,
            chapter: int.parse(chapterController.text),
          ),
          bigString: contentController.text,
        );
      } else {
        //update
        await store.contentBox.updateByIdWithBigString(
          content.id,
          content.copyWith(chapter: int.parse(chapterController.text)),
          bigString: contentController.text,
        );
      }

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
      showTMessageDialogError(context, title: Text('_save'), e.toString());
    }
  }

  void _updateApyar() async {
    try {
      setState(() {
        isLoading = true;
      });
      apyar = apyar.copyWith(title: titleController.text, date: DateTime.now());
      // await _services.getApyarDB().updateById(apyar.id, apyar);
      await context.read<ApyarListCubit>().update(apyar);

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showTSnackBar(context, 'Apyar Updated');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      showTMessageDialogError(context, e.toString());
    }
  }
}
