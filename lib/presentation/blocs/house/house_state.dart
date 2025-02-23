import 'package:equatable/equatable.dart';
import 'package:home_clean/core/base/base_model.dart';

import '../../../domain/entities/house/house.dart';

abstract class HouseState extends Equatable {
  const HouseState();
}

class HouseInitial extends HouseState {
  @override
  List<Object> get props => [];
}

class HouseLoading extends HouseState {
  @override
  List<Object> get props => [];
}

class HouseLoaded extends HouseState {
  final BaseResponse<House> houses;

  HouseLoaded({required this.houses});

  @override
  List<Object> get props => [houses];
}

class HouseError extends HouseState {
  final String message;

  HouseError({required this.message});

  @override
  List<Object> get props => [message];
}


