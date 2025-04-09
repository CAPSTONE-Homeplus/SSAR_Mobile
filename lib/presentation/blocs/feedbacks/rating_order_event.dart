part of 'rating_order_bloc.dart';

abstract class RatingOrderEvent extends Equatable {
  const RatingOrderEvent();

  @override
  List<Object> get props => [];
}

class SubmitRatingEvent extends RatingOrderEvent {
  final RatingRequest ratingRequest;

  const SubmitRatingEvent({required this.ratingRequest});

  @override
  List<Object> get props => [ratingRequest];
}

class ResetRatingEvent extends RatingOrderEvent {}