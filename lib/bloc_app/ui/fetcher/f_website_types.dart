import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:t_html_parser/core/dom_selector.dart';
import 'package:t_html_parser/t_html_parser.dart';

import 'fetcher_types.dart';

class FWebsite {
  final String title;
  final String desc;
  final String url;
  final FWebsiteListQuery listQuery;
  final FWebsitePaginationQuery paginationQuery;
  final FWebsiteDetailQuery detailQuery;

  const FWebsite({
    required this.title,
    this.desc = '',
    required this.url,
    required this.listQuery,
    required this.paginationQuery,
    required this.detailQuery,
  });
}

class FWebsiteListQuery {
  final String selectorAll;
  final FWebsiteQuery titleQuery;
  final FWebsiteQuery urlQuery;
  final FWebsiteQuery coverUrlQuery;

  const FWebsiteListQuery({
    required this.selectorAll,
    required this.titleQuery,
    required this.urlQuery,
    required this.coverUrlQuery,
  });

  List<FetchListItem> getResult(String html, {required String hostUrl}) {
    final list = DomSelector.getResultList(
      html,
      selectorAll: selectorAll,
      // selectorAll: '.g-3 .col-6',
      queries: [
        DomSingleQuery((ele) => titleQuery.getQueryResult(ele)),
        DomSingleQuery((ele) => urlQuery.getQueryResult(ele)),
        DomSingleQuery((ele) => coverUrlQuery.getQueryResult(ele)),
        // DomSingleQuery(
        //   (ele) => ele.getQuerySelectorText(selector: '.card-title'),
        // ),
        // DomSingleQuery(
        //   (ele) => ele.getQuerySelectorAttr(selector: 'a', attr: 'href'),
        // ),
        // DomSingleQuery(
        //   (ele) => ele.getQuerySelectorAttr(selector: 'img', attr: 'src'),
        // ),
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
    return items;
  }
}

class FWebsitePaginationQuery {
  final String selectorAll;
  final FWebsiteQuery textQuery;
  final FWebsiteQuery urlQuery;

  const FWebsitePaginationQuery({
    required this.selectorAll,
    required this.textQuery,
    required this.urlQuery,
  });

  List<FetchListPagiItem> getResult(String html, {required String hostUrl}) {
    final pagiResultList = DomSelector.getResultList(
      html,
      // selectorAll: '.pagination .page-item',
      selectorAll: selectorAll,
      queries: [
        // DomSingleQuery((ele) => ele.getQuerySelectorText(selector: 'a')),
        // DomSingleQuery(
        //   (ele) => ele.getQuerySelectorAttr(selector: 'a', attr: 'href'),
        // ),
        DomSingleQuery((ele) => textQuery.getQueryResult(ele)),
        DomSingleQuery((ele) => urlQuery.getQueryResult(ele)),
        DomSingleQuery((ele) => ele.className),
      ],
    );
    // print(pagiResultList);

    final pagiList = <FetchListPagiItem>[];

    for (var pagi in pagiResultList) {
      if (pagi[0].isEmpty) continue;

      final pageUrl = pagi[1].startsWith('/')
          ? ('$hostUrl/${pagi[1]}').getNormalizeSlash.replaceAll(':/', '://')
          : pagi[1];
      bool active = pagi[2].contains('active');
      pagiList.add(
        FetchListPagiItem(title: pagi[0], url: pageUrl, active: active),
      );
    }
    return pagiList;
  }
}

class FWebsiteDetailQuery {
  final List<FWebsiteQuery> queries;

  const FWebsiteDetailQuery({required this.queries});

  List<FetchItemReturnData> getResult(String html, {required String hostUrl}) {
    final result = DomSelector.getResult(
      html,
      queries: queries
          .map((e) => DomSingleQuery((ele) => e.getQueryResult(ele)))
          .toList(),
      // queries: [
      //   DomSingleQuery(
      //     (ele) => ele.getQuerySelectorAttr(
      //       selector: '.book-detail-cover',
      //       attr: 'src',
      //     ),
      //   ),
      //   DomSingleQuery(
      //     (ele) => ele.getQuerySelectorText(selector: '#bookTitle'),
      //   ),
      //   DomSingleQuery(
      //     (ele) => ele.getQuerySelectorHtml(selector: '#reader').cleanHtmlTag(),
      //   ),
      // ],
    );

    final list = result.map((e) {
      String result = e;
      // url
      if (e.startsWith('/')) {
        result = ('$hostUrl/$e').getNormalizeSlash.replaceAll(':/', '://');
      }
      return FetchItemReturnData(
        result: result,
        type: result.startsWith('http')
            ? FetchItemReturnDataType.image
            : FetchItemReturnDataType.text,
      );
    }).toList();
    return list;
  }
}

///
/// ### `attribute` [html,text,html-attr] ### default [text]
///
/// ### `selector` is Empty [current element]
///
class FWebsiteQuery {
  final String selector;
  final String attribute;

  /// html,text,html-attr //default text

  const FWebsiteQuery({this.selector = '', this.attribute = 'text'});

  String getQueryResult(Element ele) {
    if (selector.isEmpty) {
      //current element
      if (attribute == 'html') {
        return ele.innerHtml.cleanHtmlTag();
      }
      if (attribute != 'text') {
        return ele.attributes[attribute] ?? '';
      }
      return ele.text;
    } else {
      if (attribute == 'html') {
        return ele.getQuerySelectorHtml(selector: selector).cleanHtmlTag();
      }
      if (attribute != 'text') {
        return ele.getQuerySelectorAttr(selector: selector, attr: attribute);
      }
      return ele.getQuerySelectorText(selector: selector);
    }
  }
}
