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
      FWebsite(
        title: 'adult-manhwamyanmar',
        desc: 'Manhwa 18+ မြန်မာဘာသာပြန် ',
        url: 'https://adult.manhwamyanmar.com',
        type: FWebsiteType.managa,
        listQuery: FWebsiteListQuery(
          selectorAll: '.gridmini-posts .gridmini-grid-post',
          titleQuery: FWebsiteQuery(selector: '.gridmini-grid-post-title'),
          urlQuery: FWebsiteQuery(
            selector: '.gridmini-grid-post-thumbnail-link',
            attribute: 'href',
          ),
          coverUrlQuery: FWebsiteQuery(
            selector: '.gridmini-grid-post-thumbnail-img',
            attribute: 'src',
          ),
        ),
        managContentQuery: FWebsiteManagContentQuery(
          titleQuery: FWebsiteQuery(selector: '.post-title'),
          coverUrlQuery: FWebsiteQuery(
            selector: '.wp-post-image',
            attribute: 'src',
          ),
          contentQuery: FWebsiteQuery(
            selector: '.entry-content',
            attribute: 'html',
          ),
          selectorAll: '.entry-content center a',
          chapterSingleTitleQuery: FWebsiteQuery(selector: 'button'),
          chapterSingleUrlQuery: FWebsiteQuery(attribute: 'href'),
        ),
        managListDetailQuery: FWebsiteManagListDetailQuery(
          selectorAll: '.entry-content img',
          coverUrlQuery: FWebsiteQuery(attribute: 'data-src'),
        ),
        paginationQuery: FWebsitePaginationQuery(
          selectorAll: '.nav-links a',
          textQuery: FWebsiteQuery(),
          urlQuery: FWebsiteQuery(attribute: 'href'),
        ),
        detailQuery: FWebsiteDetailQuery(
          queries: [
            FWebsiteQuery(selector: '.entry-content img', attribute: 'src'),
          ],
        ),
      ),
    ];
    return list;
  }
}
