import 'package:equatable/equatable.dart';

abstract class AdditionalServiceEvent extends Equatable {
  const AdditionalServiceEvent();

  @override
  List<Object?> get props => [];
}

class FetchAdditionalService extends AdditionalServiceEvent {
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  const FetchAdditionalService({this.search, this.orderBy, this.page, this.size});

  @override
  List<Object?> get props => [search, orderBy, page, size];
}
