  import 'package:equatable/equatable.dart';

  abstract class HouseEvent extends Equatable {
    const HouseEvent();
  }

  class GetHouseByBuilding extends HouseEvent {
    final String buildingId;
    final String? search;
    final String? orderBy;
    final int? page;
    final int? size;

    GetHouseByBuilding({
      required this.buildingId,
      this.search,
      this.orderBy,
      this.page,
      this.size
    });

    @override
    List<Object?> get props => [buildingId, search, orderBy, page, size];
  }

  class GetHouseById extends HouseEvent {
    final String houseId;

    GetHouseById({
      required this.houseId,
    });

    @override
    List<Object?> get props => [houseId];
  }