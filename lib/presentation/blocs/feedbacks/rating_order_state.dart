part of 'rating_order_bloc.dart';

abstract class RatingOrderState {}

class RatingOrderInitial extends RatingOrderState {}

class RatingOrderLoading extends RatingOrderState {}

class RatingOrderLoaded extends RatingOrderState {
  final bool isSuccess;

   RatingOrderLoaded({this.isSuccess = false});
}

class RatingOrderError extends RatingOrderState {
  final String message;

  RatingOrderError({required this.message});
}