import 'package:equatable/equatable.dart';

class LaundryServiceType extends Equatable {
  String? id;
  String? type;
  String? name;
  String? description;
  String? status;
  String? createdAt;
  String? updatedAt;

  LaundryServiceType({
    this.id,
    this.type,
    this.name,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    name,
    description,
    status,
    createdAt,
    updatedAt,
  ];
}