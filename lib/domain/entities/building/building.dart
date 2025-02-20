import 'package:equatable/equatable.dart';

class Building extends Equatable{
  String? id;
  String? name;
  String? longitude;
  String? latitude;
  String? code;
  String? createdAt;
  String? updatedAt;
  String? hubId;
  String? clusterId;
  String? status;
  
  Building({
    this.id,
    this.name,
    this.longitude,
    this.latitude,
    this.code,
    this.createdAt,
    this.updatedAt,
    this.hubId,
    this.clusterId,
    this.status,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    longitude,
    latitude,
    code,
    createdAt,
    updatedAt,
    hubId,
    clusterId,
    status,
  ];

}