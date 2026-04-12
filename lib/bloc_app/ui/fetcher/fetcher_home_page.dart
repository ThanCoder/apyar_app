import 'package:apyar_app/bloc_app/ui/fetcher/f_website_types.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetch_item_response_bookmark_list_page.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetch_list_home_screen.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetch_website_services.dart';
import 'package:apyar_app/core/extensions/buildcontext_extensions.dart';
import 'package:flutter/material.dart';

class FetcherHomePage extends StatefulWidget {
  const FetcherHomePage({super.key});

  @override
  State<FetcherHomePage> createState() => _FetcherHomePageState();
}

class _FetcherHomePageState extends State<FetcherHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fetcher List')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.goRoute(
                      builder: (context) => FetchItemResponseBookmarkListPage(),
                    );
                  },
                  child: Chip(
                    label: Text('Bookmark'),
                    avatar: Icon(Icons.bookmark_added),
                    mouseCursor: SystemMouseCursors.click,
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: FetchWebsiteServices.instance.getAll(),
            builder: (context, snapshot) {
              final list = snapshot.data ?? [];
              return SliverList.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: list.length,
                itemBuilder: (context, index) => _listItem(list[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _listItem(FWebsite website) {
    return ListTile(
      title: Text(website.title),
      subtitle: website.desc.isEmpty
          ? null
          : Text(website.desc, style: TextStyle(fontSize: 13)),
      onTap: () {
        context.goRoute(
          builder: (context) => FetchListHomeScreen(website: website),
        );
      },
    );
  }
}
