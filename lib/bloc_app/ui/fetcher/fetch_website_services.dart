import 'package:apyar_app/bloc_app/ui/fetcher/f_website_types.dart';

class FetchWebsiteServices {
  static final FetchWebsiteServices instance = FetchWebsiteServices._();
  const FetchWebsiteServices._();
  factory FetchWebsiteServices() => instance;

  Future<List<FWebsite>> getAll() async {
    final list = <FWebsite>[
      FWebsite(
        title: 'AllSarOak',
        desc: 'အောစာအုပ်များ Website',
        url: 'https://allsaroak.com',
        listQuery: FWebsiteListQuery(
          selectorAll: '.g-3 .col-6',
          titleQuery: FWebsiteQuery(selector: '.card-title'),
          urlQuery: FWebsiteQuery(selector: 'a', attribute: 'href'),
          coverUrlQuery: FWebsiteQuery(selector: 'img', attribute: 'src'),
        ),
        paginationQuery: FWebsitePaginationQuery(
          selectorAll: '.pagination .page-item',
          textQuery: FWebsiteQuery(selector: 'a'),
          urlQuery: FWebsiteQuery(selector: 'a', attribute: 'href'),
        ),
        detailQuery: FWebsiteDetailQuery(
          queries: [
            FWebsiteQuery(selector: '.book-detail-cover', attribute: 'src'),
            FWebsiteQuery(selector: '#bookTitle'),
            FWebsiteQuery(selector: '#reader', attribute: 'html'),
          ],
        ),
      ),
      FWebsite(
        title: 'DrMgNyo',
        desc: 'Dr Mg Nyo [အပြာစာပေ]',
        url: 'https://drmgnyo.com',
        listQuery: FWebsiteListQuery(
          selectorAll: '.clean-grid-posts-container .clean-grid-grid-post',
          titleQuery: FWebsiteQuery(selector: '.clean-grid-grid-post-title'),
          urlQuery: FWebsiteQuery(
            selector: '.clean-grid-grid-post-title a',
            attribute: 'href',
          ),
          coverUrlQuery: FWebsiteQuery(
            selector: '.clean-grid-grid-post-thumbnail-img',
            attribute: 'src',
          ),
        ),
        paginationQuery: FWebsitePaginationQuery(
          selectorAll: '.wp-pagenavi a',
          textQuery: FWebsiteQuery(),
          urlQuery: FWebsiteQuery(attribute: 'href'),
        ),
        detailQuery: FWebsiteDetailQuery(
          queries: [
            FWebsiteQuery(selector: '.wp-post-image', attribute: 'src'),
            FWebsiteQuery(selector: '.post-title'),
            FWebsiteQuery(selector: '.entry-content', attribute: 'html'),
          ],
        ),
      ),
    ];
    return list;
  }
}
