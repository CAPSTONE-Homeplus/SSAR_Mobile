import 'package:home_clean/domain/entities/extra_service/extra_service.dart';

abstract class ExtraServiceState {}

class ExtraServiceInitialState extends ExtraServiceState {}

class ExtraServiceLoadingState extends ExtraServiceState {}

class ExtraServiceErrorState extends ExtraServiceState {
  final String message;

  ExtraServiceErrorState({required this.message});
}

class ExtraServiceSuccessState extends ExtraServiceState {
  final List<ExtraService> extraServices;

  ExtraServiceSuccessState({required this.extraServices});
}
