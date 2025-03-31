import 'package:equatable/equatable.dart';

abstract class LaundryItemTypeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetLaundryItemTypeByService extends LaundryItemTypeEvent {
  final String serviceTypeId;

  GetLaundryItemTypeByService(this.serviceTypeId);

  @override
  List<Object> get props => [serviceTypeId];
}
