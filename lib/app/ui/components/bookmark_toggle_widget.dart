import 'dart:async';

import 'package:apyar_app/app/core/models/apyar.dart';
import 'package:apyar_app/app/core/models/bookmark.dart';
import 'package:flutter/material.dart';
import 'package:t_db/t_db.dart';
import 'package:t_widgets/t_widgets.dart';

final _box = TDB.getInstance().getBox<Bookmark>();

class BookmarkToggleWidget extends StatefulWidget {
  final Apyar apyar;
  const BookmarkToggleWidget({super.key, required this.apyar});

  @override
  State<BookmarkToggleWidget> createState() => _BookmarkToggleWidgetState();
}

class _BookmarkToggleWidgetState extends State<BookmarkToggleWidget> {
  late StreamSubscription<TDBoxStreamEvent> _subscription;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
    _subscription = _box.stream.listen((data) {
      if (!mounted || data.id == null) return;
      if (data.type == TBEventType.update) return;
      // add ဆိုရင် စစ်ဆေးတော့မယ်
      if (data.type == TBEventType.add) {
        init();
        return;
      }
      // bookmark id တူလားစစ်မယ်
      if (bookmark != null &&
          data.type == TBEventType.delete &&
          bookmark!.autoId == data.id) {
        bookmark = null;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Bookmark? bookmark;
  bool isLoading = false;
  void init() async {
    try {
      setState(() {
        isLoading = true;
      });
      bookmark = await _box.getOne(
        (value) => value.apyarId == widget.apyar.autoId,
      );

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('[]: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(width: 25, height: 25, child: TLoader(size: 25));
    }
    return IconButton(
      onPressed: () async {
        if (bookmark == null) {
          final newBook = Bookmark(
            apyarId: widget.apyar.autoId,
            title: widget.apyar.title,
            date: DateTime.now(),
          );
          await _box.add(newBook);
          bookmark = newBook;
        } else {
          if (bookmark == null) return;
          await _box.deleteById(bookmark!.autoId);
          bookmark = null;
        }
        if (!mounted) return;
        setState(() {});
      },
      icon: Icon(
        color: bookmark == null ? Colors.blue : Colors.red,
        bookmark == null ? Icons.bookmark_add : Icons.bookmark_remove,
      ),
    );
  }
}
