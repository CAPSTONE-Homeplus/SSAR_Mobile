class BaseResponse<T> {
  int size;
  int page;
  int total;
  int totalPages;
  List<T> items;

  BaseResponse({
    required this.size,
    required this.page,
    required this.total,
    required this.totalPages,
    required this.items,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return BaseResponse(
      size: json['size'],
      page: json['page'],
      total: json['total'],
      totalPages: json['totalPages'],
      items: (json['items'] as List<dynamic>)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'size': size,
      'page': page,
      'total': total,
      'totalPages': totalPages,
      'items': items.map(toJsonT).toList(),
    };
  }
}
