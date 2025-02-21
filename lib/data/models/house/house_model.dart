class HouseModel {
  String? id;
  String? no;
  String? numberOfRoom;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? code;
  int? bedroomCount;
  int? bathroomCount;
  bool? hasBalcony;
  String? furnishingStatus;
  String? squareMeters;
  String? orientation;
  String? contactTerms;
  String? occupacy;
  String? buildingId;
  String? houseTypeId;

  HouseModel({
    this.id,
    this.no,
    this.numberOfRoom,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.code,
    this.bedroomCount,
    this.bathroomCount,
    this.hasBalcony,
    this.furnishingStatus,
    this.squareMeters,
    this.orientation,
    this.contactTerms,
    this.occupacy,
    this.buildingId,
    this.houseTypeId
  });

  HouseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    no = json['no'];
    numberOfRoom = json['numberOfRoom'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    code = json['code'];
    bedroomCount = json['bedroomCount'];
    bathroomCount = json['bathroomCount'];
    hasBalcony = json['hasBalcony'];
    furnishingStatus = json['furnishingStatus'];
    squareMeters = json['squareMeters'];
    orientation = json['orientation'];
    contactTerms = json['contactTerms'];
    occupacy = json['occupacy'];
    buildingId = json['buildingId'];
    houseTypeId = json['houseTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['no'] = no;
    data['numberOfRoom'] = numberOfRoom;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['code'] = code;
    data['bedroomCount'] = bedroomCount;
    data['bathroomCount'] = bathroomCount;
    data['hasBalcony'] = hasBalcony;
    data['furnishingStatus'] = furnishingStatus;
    data['squareMeters'] = squareMeters;
    data['orientation'] = orientation;
    data['contactTerms'] = contactTerms;
    data['occupacy'] = occupacy;
    data['buildingId'] = buildingId;
    data['houseTypeId'] = houseTypeId;
    return data;
  }
}