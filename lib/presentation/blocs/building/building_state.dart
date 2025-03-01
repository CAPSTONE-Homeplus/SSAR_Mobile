import 'package:equatable/equatable.dart';
import 'package:home_clean/core/base/base_model.dart';

import '../../../domain/entities/building/building.dart';

abstract class BuildingState extends Equatable {
  const BuildingState();
}

class BuildingInitial extends BuildingState {
  @override
  List<Object?> get props => [];
}

class BuildingLoading extends BuildingState {
  @override
  List<Object?> get props => [];
}

class BuildingLoaded extends BuildingState {
  final BaseResponse<Building> buildings;

  BuildingLoaded({
    required this.buildings,
  });

  @override
  List<Object?> get props => [buildings];
}

class OneBuildingLoaded extends BuildingState {
  final Building building;

  OneBuildingLoaded({required this.building});

  @override
  List<Object?> get props => [building];
}

class BuildingError extends BuildingState {
  final String message;

  BuildingError({required this.message});

  @override
  List<Object?> get props => [message];
}