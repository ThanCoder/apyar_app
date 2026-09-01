import 'package:apyar_app/core/db/du_db.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:flutter/material.dart';

class DesktopHomePage extends StatefulWidget {
  const new({super.key});

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
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
              return SliverList.builder(
                itemCount: data.unwrap().length,
                itemBuilder: (context, index) =>
                    _listItem(data.unwrap()[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _listItem(Apyar apy) {
    return ListTile(title: Text(apy.title));
  }
}
