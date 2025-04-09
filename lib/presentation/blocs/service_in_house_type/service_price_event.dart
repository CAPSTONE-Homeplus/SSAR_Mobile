abstract class ServicePriceEvent {}

class GetServicePrice extends ServicePriceEvent {
  final String houseId;
  final String serviceId;

  GetServicePrice({required this.houseId, required this.serviceId});
}
