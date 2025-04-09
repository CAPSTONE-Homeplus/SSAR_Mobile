import '../../../domain/entities/service_in_house_type/house_type.dart';

abstract class ServicePriceState {}

class ServicePriceInitial extends ServicePriceState {}

class ServicePriceLoading extends ServicePriceState {}

class ServicePriceLoaded extends ServicePriceState {
  final ServiceInHouseType servicePrice;

  ServicePriceLoaded({required this.servicePrice});
}

class ServicePriceError extends ServicePriceState {
  final String message;

  ServicePriceError({required this.message});
}
