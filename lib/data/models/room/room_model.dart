class RoomModel{
  String? id;
  String? name;
  String? status;
  int? size;
  bool? furnitureIncluded;
  String? createdAt;
  String? updatedAt;
  String? squareMeters;
  String? houseId;
  String? roomTypeId;
  String? code;

  RoomModel({
    this.id,
    this.name,
    this.status,
    this.size,
    this.furnitureIncluded,
    this.createdAt,
    this.updatedAt,
    this.squareMeters,
    this.houseId,
    this.roomTypeId,
    this.code,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      size: json['size'],
      furnitureIncluded: json['furnitureIncluded'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      squareMeters: json['squareMeters'],
      houseId: json['houseId'],
      roomTypeId: json['roomTypeId'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['size'] = size;
    data['furnitureIncluded'] = furnitureIncluded;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['squareMeters'] = squareMeters;
    data['houseId'] = houseId;
    data['roomTypeId'] = roomTypeId;
    data['code'] = code;
    return data;
  }
}