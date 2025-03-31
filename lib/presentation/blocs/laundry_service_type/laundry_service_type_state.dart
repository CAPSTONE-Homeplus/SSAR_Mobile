import 'package:equatable/equatable.dart';
import 'package:home_clean/core/base/base_model.dart';
import 'package:home_clean/domain/entities/laundry_service_type/laundry_service_type.dart';

import '../../../domain/entities/laundry_item_type/laundry_item_type.dart';

abstract class LaundryServiceTypeState extends Equatable {
  @override
  List<Object> get props => [];
}

class LaundryServiceTypeInitial extends LaundryServiceTypeState {}

class LaundryServiceTypeLoading extends LaundryServiceTypeState {}

class LaundryServiceTypeLoaded extends LaundryServiceTypeState {
  final BaseResponse<LaundryServiceType> laundryServiceTypes;

  LaundryServiceTypeLoaded(this.laundryServiceTypes);

  @override
  List<Object> get props => [laundryServiceTypes];
}

class LaundryServiceTypeError extends LaundryServiceTypeState {
  final String message;

  LaundryServiceTypeError(this.message);

  @override
  List<Object> get props => [message];
}

