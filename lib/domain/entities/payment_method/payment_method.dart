import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  String? id;
  String? name;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? status;

  PaymentMethod({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  List<Object?> get props => [
    id,
    name,
    description,
    createdAt,
    updatedAt,
    status,
  ];
}