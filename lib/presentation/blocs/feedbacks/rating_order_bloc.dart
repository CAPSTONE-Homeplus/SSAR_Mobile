import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import 'package:home_clean/domain/repositories/order_repository.dart';

import '../../../domain/entities/rating_request/rating_request.dart';

part 'rating_order_event.dart';
part 'rating_order_state.dart';

class RatingOrderBloc extends Bloc<RatingOrderEvent, RatingOrderState> {
  final OrderRepository orderRepository;

  RatingOrderBloc({required this.orderRepository})
      : super(RatingOrderInitial()) {
    on<SubmitRatingEvent>(_onSubmitRating);
  }

  void _onSubmitRating(
      SubmitRatingEvent event,
      Emitter<RatingOrderState> emit
      ) async {
    emit(RatingOrderLoading());
    try {
      final result = await orderRepository.ratingOrder(event.ratingRequest);

      if (result) {
        emit(RatingOrderLoaded());
      } else {
        emit(RatingOrderError(message: 'Đánh giá không thành công'));
      }
    } catch (e) {
      emit(RatingOrderError(message: e.toString()));
    }
  }
}