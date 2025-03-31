import 'package:equatable/equatable.dart';
import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/domain/entities/laundry_item_type/laundry_item_type.dart';

abstract class LaundryItemTypeState extends Equatable {
  @override
  List<Object> get props => [];
}

class LaundryItemTypeInitial extends LaundryItemTypeState {}

class LaundryItemTypeLoading extends LaundryItemTypeState {}

class LaundryItemTypeError extends LaundryItemTypeState {
  final String message;

  LaundryItemTypeError(this.message);

  @override
  List<Object> get props => [message];
}

class LaundryItemTypeLoaded extends LaundryItemTypeState {
  final BaseResponse<LaundryItemType> laundryItemTypes;

  LaundryItemTypeLoaded(this.laundryItemTypes);

  @override
  List<Object> get props => [laundryItemTypes];
}
