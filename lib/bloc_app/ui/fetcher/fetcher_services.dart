import 'dart:io';

import 'package:apyar_app/bloc_app/ui/fetcher/fetcher_types.dart';
import 'package:apyar_app/more_libs/setting/core/path_util.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:t_client/t_client.dart';
import 'package:t_html_parser/core/dom_selector.dart';
import 'package:t_html_parser/t_html_parser.dart';

class FetcherServices {
  static final FetcherServices instance = FetcherServices._();
  FetcherServices._();
  factory FetcherServices() => instance;

  final client = TClient();

  Future<FetchListResponse> fetchList(
    String url, {
    required String hostUrl,
    bool usedCache = true,
  }) async {
    final html = await _getCacheHtml(
      url,
      cacheName: "allsaroak-${url.getCleanBackSlash.getName()}",
      usedCache: usedCache,
    );

    final list = DomSelector.getResultList(
      html,
      selectorAll: '.g-3 .col-6',
      queries: [
        DomSingleQuery(
          (ele) => ele.getQuerySelectorText(selector: '.card-title'),
        ),
        DomSingleQuery(
          (ele) => ele.getQuerySelectorAttr(selector: 'a', attr: 'href'),
        ),
        DomSingleQuery(
          (ele) => ele.getQuerySelectorAttr(selector: 'img', attr: 'src'),
        ),
      ],
    );
    final pagi = DomSelector.getResultList(
      html,
      selectorAll: '.pagination .page-item',
      queries: [
        DomSingleQuery((ele) => ele.getQuerySelectorText(selector: 'a')),
        DomSingleQuery(
          (ele) => ele.getQuerySelectorAttr(selector: 'a', attr: 'href'),
        ),
      ],
    );
    final items = list.map((e) {
      final pageUrl = e[1].startsWith('/')
          ? ('$hostUrl/${e[1]}').getNormalizeSlash.replaceAll(':/', '://')
          : e[1];
      final coverUrl = e[2].startsWith('/')
          ? ('$hostUrl/${e[2]}').getNormalizeSlash.replaceAll(':/', '://')
          : e[2];
      return FetchListItem(
        title: e[0],
        url: pageUrl,
        coverUrl: coverUrl,
        hostUrl: hostUrl,
      );
    }).toList();
    final pagiList = pagi.map((e) {
      final pageUrl = e[1].startsWith('/')
          ? ('$hostUrl/${e[1]}').getNormalizeSlash.replaceAll(':/', '://')
          : e[1];
      return FetchListPagiItem(title: e[0], url: pageUrl);
    }).toList();

    return FetchListResponse(items: items, pagiList: pagiList);
  }

  Future<FetchItemResponse> fetchItemDetail(
    FetchListItem item, {
    bool usedCache = true,
  }) async {
    final html = await _getCacheHtml(
      item.url,
      cacheName: '${item.title}-cache-page.html',
      usedCache: usedCache,
    );

    final result = DomSelector.getResult(
      html,
      queries: [
        DomSingleQuery(
          (ele) => ele.getQuerySelectorAttr(
            selector: '.book-detail-cover',
            attr: 'src',
          ),
        ),
        DomSingleQuery(
          (ele) => ele.getQuerySelectorText(selector: '#bookTitle'),
        ),
        DomSingleQuery(
          (ele) => ele.getQuerySelectorHtml(selector: '#reader').cleanHtmlTag(),
        ),
      ],
    );

    final list = result.map((e) {
      String result = e;
      // url
      if (e.startsWith('/')) {
        result = ('${item.hostUrl}/$e').getNormalizeSlash.replaceAll(
          ':/',
          '://',
        );
      }
      return FetchItemReturnData(
        result: result,
        type: result.startsWith('http')
            ? FetchItemReturnDataType.image
            : FetchItemReturnDataType.text,
      );
    }).toList();
    return FetchItemResponse(item: item, list: list);
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
