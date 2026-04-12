import 'dart:io';

import 'package:apyar_app/bloc_app/ui/fetcher/fetcher_types.dart';
import 'package:apyar_app/more_libs/setting/core/path_util.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:t_client/t_client.dart';

import 'f_website_types.dart';

class FetcherServices {
  static final FetcherServices instance = FetcherServices._();
  FetcherServices._();
  factory FetcherServices() => instance;

  final client = TClient();

  Future<FetchListResponse> fetchList(
    String url, {
    required FWebsite website,
    bool usedCache = true,
  }) async {
    final html = await _getCacheHtml(
      url,
      cacheName: "${website.title}-${url.getCleanBackSlash.getName()}",
      usedCache: usedCache,
    );

    return FetchListResponse(
      items: website.listQuery.getResult(html, hostUrl: website.url),
      pagiList: website.paginationQuery.getResult(html, hostUrl: website.url),
    );
  }

  Future<FetchItemResponse> fetchItemDetail(
    FetchListItem item, {
    required FWebsite website,
    bool usedCache = true,
  }) async {
    final html = await _getCacheHtml(
      item.url,
      cacheName: '${item.title}-cache-page.html',
      usedCache: usedCache,
    );

    return FetchItemResponse(
      item: item,
      list: website.detailQuery.getResult(html, hostUrl: website.url),
    );
  }

  Future<String> _getCacheHtml(
    String url, {
    required String cacheName,
    bool usedCache = true,
  }) async {
    final respFile = File(PathUtil.getCachePath(name: cacheName));
    String html = '';
    if (usedCache && respFile.existsSync()) {
      html = await respFile.readAsString();
    } else {
      final res = await client.get(url);
      html = res.data.toString();
      
      if (usedCache) {
        await respFile.writeAsString(html);
      }
    }
    return html;
  }
}
