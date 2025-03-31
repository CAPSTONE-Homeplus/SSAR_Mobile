import 'package:equatable/equatable.dart';

abstract class LaundryServiceTypeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetLaundryServiceTypes extends LaundryServiceTypeEvent {}

class GetLaundryItemTypeByService extends LaundryServiceTypeEvent {
  final String serviceTypeId;

  GetLaundryItemTypeByService(this.serviceTypeId);

  @override
  List<Object> get props => [serviceTypeId];
}