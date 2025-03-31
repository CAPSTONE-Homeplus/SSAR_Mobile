import 'package:equatable/equatable.dart';
import 'package:home_clean/core/base/base_model.dart';

import '../../../domain/entities/additional_service/additional_service_model.dart';

abstract class AdditionalServiceState extends Equatable {
  const AdditionalServiceState();

  @override
  List<Object?> get props => [];
}

class AdditionalServiceInitial extends AdditionalServiceState {}

class AdditionalServiceLoading extends AdditionalServiceState {}

class AdditionalServiceLoaded extends AdditionalServiceState {
  final BaseResponse<AdditionalService> services;
  final int total;
  final int page;
  final int totalPages;

  const AdditionalServiceLoaded({
    required this.services,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [services, total, page, totalPages];
}

class AdditionalServiceError extends AdditionalServiceState {
  final String message;

  const AdditionalServiceError(this.message);

  @override
  List<Object?> get props => [message];
}
