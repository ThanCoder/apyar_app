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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _box.getOne((value) => value.apyarId == widget.apyar.autoId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return Text('Loading...');
          return SizedBox(width: 25, height: 25, child: TLoader(size: 25));
        }
        Bookmark? bookmark = snapshot.data;

        return IconButton(
          onPressed: () async {
            if (snapshot.data == null) {
              await _box.add(
                Bookmark(
                  apyarId: widget.apyar.autoId,
                  title: widget.apyar.title,
                  date: DateTime.now(),
                ),
              );
            } else {
              if (bookmark == null) return;
              await _box.deleteById(bookmark.autoId);
            }
            if (!mounted) return;
            setState(() {});
          },
          icon: Icon(
            color: bookmark == null ? Colors.blue : Colors.red,
            bookmark == null ? Icons.bookmark_add : Icons.bookmark_remove,
          ),
        );
      },
    );
  }
}
