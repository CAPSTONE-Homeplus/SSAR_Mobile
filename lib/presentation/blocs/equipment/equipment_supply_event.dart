abstract class EquipmentSupplyEvent {}

class GetEquipmentSupplies extends EquipmentSupplyEvent {
  final String serviceId;
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  GetEquipmentSupplies({
    required this.serviceId,
    this.search,
    this.orderBy,
    this.page,
    this.size,
  });
}
