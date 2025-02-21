import 'package:equatable/equatable.dart';

class House extends Equatable{
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

  House({
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

  @override
  List<Object?> get props => [id, no, numberOfRoom, status, createdAt, updatedAt, code, bedroomCount, bathroomCount, hasBalcony, furnishingStatus, squareMeters, orientation, contactTerms, occupacy, buildingId, houseTypeId];
}