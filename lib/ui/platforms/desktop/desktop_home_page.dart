import 'package:apyar_app/core/db/du_db.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/ui/platforms/desktop/desktop_reader_page.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class DesktopHomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  ColorScheme get col => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CustomScrollView(
        slivers: [
          FutureBuilder(
            future: DuDB.instance.apyarBox.getAll(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SliverToBoxAdapter(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              final data = snapshot.data!;
              if (data.isErr) {
                return SliverToBoxAdapter(
                  child: Text('Error: ${data.unwrapError()}'),
                );
              }
              return SliverPadding(
                padding: .symmetric(vertical: 5, horizontal: 10),
                sliver: SliverList.separated(
                  separatorBuilder: (context, index) => SizedBox(height: 5),
                  itemCount: data.unwrap().length,
                  itemBuilder: (context, index) =>
                      _listItem(data.unwrap()[index]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  int? currentId;

  Widget _listItem(Apyar apyar) {
    return ListTile(
      tileColor: currentId == apyar.generatedId
          ? col.primaryContainer
          : col.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      // leading: Icon(Icons.favorite_outline),
      title: Text(
        apyar.title,
        style: TextStyle(color: col.onSurface, fontWeight: .w600, fontSize: 14),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        color: col.onSurfaceVariant,
      ),
      onTap: () async {
        currentId = apyar.generatedId;
        await context.pushMaterialPageRoute(
          builder: (mainCtx) => DesktopReaderPage(apyar: apyar),
        );
        setState(() {});
      },
    );
  }
}
