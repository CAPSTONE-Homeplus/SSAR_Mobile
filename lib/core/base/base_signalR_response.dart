class BaseSignalrResponse<T> {
  String type;
  T data;

  BaseSignalrResponse({required this.type, required this.data});

  /// Generic factory để parse dữ liệu
  factory BaseSignalrResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return BaseSignalrResponse(
      type: json['Type'],
      data: fromJsonT(json['Data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Type': type,
      'Data': (data as dynamic).toJson(), // Ép kiểu về dynamic để gọi `toJson`
    };
  }
}