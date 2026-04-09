//fetch item
class FetchItemResponse {
  final FetchListItem item;
  final List<FetchItemReturnData> list;

  const FetchItemResponse({required this.item, required this.list});

  Map<String, dynamic> toJson() {
    return {
      'item': item.toJson(),
      'list': list.map((x) => x.toJson()).toList(),
    };
  }

  factory FetchItemResponse.fromJson(Map<String, dynamic> json) {
    return FetchItemResponse(
      item: FetchListItem.fromJson(json['item']),
      list: List<FetchItemReturnData>.from(
        json['list']?.map((x) => FetchItemReturnData.fromJson(x)),
      ),
    );
  }

  FetchItemResponse copyWith({
    FetchListItem? item,
    List<FetchItemReturnData>? list,
  }) {
    return FetchItemResponse(
      item: item ?? this.item,
      list: list ?? this.list,
    );
  }
}

class FetchItemReturnData {
  final String result;
  final FetchItemReturnDataType type;

  const FetchItemReturnData({
    required this.result,
    this.type = FetchItemReturnDataType.text,
  });

  Map<String, dynamic> toJson() {
    return {'result': result, 'type': type.name};
  }

  factory FetchItemReturnData.fromJson(Map<String, dynamic> json) {
    return FetchItemReturnData(
      result: json['result'],
      type: FetchItemReturnDataType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
    );
  }

  FetchItemReturnData copyWith({
    String? result,
    FetchItemReturnDataType? type,
  }) {
    return FetchItemReturnData(
      result: result ?? this.result,
      type: type ?? this.type,
    );
  }
}

enum FetchItemReturnDataType { text, image }

//fetch list
class FetchListResponse {
  final List<FetchListItem> items;
  final List<FetchListPagiItem> pagiList;

  const FetchListResponse({required this.items, required this.pagiList});
}

class FetchListItem {
  final String title;
  final String url;
  final String hostUrl;
  final String coverUrl;

  const FetchListItem({
    required this.title,
    required this.url,
    required this.hostUrl,
    required this.coverUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'url': url,
      'hostUrl': hostUrl,
      'coverUrl': coverUrl,
    };
  }

  factory FetchListItem.fromJson(Map<String, dynamic> json) {
    return FetchListItem(
      title: json['title'],
      url: json['url'],
      hostUrl: json['hostUrl'],
      coverUrl: json['coverUrl'],
    );
  }
}

class FetchListPagiItem {
  final String title;
  final String url;
  final bool active;

  const FetchListPagiItem({
    required this.title,
    required this.url,
    this.active = false,
  });
}
