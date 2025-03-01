import 'package:equatable/equatable.dart';

abstract class BuildingEvent extends Equatable {
  const BuildingEvent();
}

class GetBuildings extends BuildingEvent {
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  GetBuildings({this.search, this.orderBy, this.page, this.size});

  @override
  List<Object?> get props => [search, orderBy, page, size];
}

class GetBuilding extends BuildingEvent {
  final String? buildingId;

  GetBuilding({this.buildingId});

  @override
  List<Object?> get props => [buildingId];
}