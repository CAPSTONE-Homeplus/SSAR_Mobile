import 'package:equatable/equatable.dart';

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
  final List<Building> buildings;
  final int size;
  final int page;
  final int total;
  final int totalPages;

  BuildingLoaded({
    required this.buildings,
    required this.size,
    required this.page,
    required this.total,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [buildings, size, page, total, totalPages];
}

class BuildingError extends BuildingState {
  final String message;

  BuildingError({required this.message});

  @override
  List<Object?> get props => [message];
}