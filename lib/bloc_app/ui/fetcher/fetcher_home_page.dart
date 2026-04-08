import 'package:apyar_app/bloc_app/ui/fetcher/fetch_item_response_bookmark_list_page.dart';
import 'package:apyar_app/bloc_app/ui/fetcher/fetch_list_home_screen.dart';
import 'package:apyar_app/core/extensions/buildcontext_extensions.dart';
import 'package:flutter/material.dart';

class FetcherHomePage extends StatelessWidget {
  const FetcherHomePage({super.key});

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
          SliverFillRemaining(
            child: Center(
              child: TextButton(
                onPressed: () {
                  context.goRoute(
                    builder: (context) =>
                        FetchListHomeScreen(url: 'https://allsaroak.com'),
                  );
                },
                child: Text('https://allsaroak.com/'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
