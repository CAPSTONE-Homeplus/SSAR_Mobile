import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/repositories/service_category_repository.dart';
import 'package:home_clean/presentation/blocs/service_category/service_category_event.dart';
import 'package:home_clean/presentation/blocs/service_category/service_category_state.dart';

class ServiceCategoryBloc
    extends Bloc<ServiceCategoryEvent, ServiceCategoryState> {
  final ServiceCategoryRepository serviceCategoryRepository;

  ServiceCategoryBloc({required this.serviceCategoryRepository})
      : super(ServiceCategoryInitialState()) {
    on<GetServiceCategoriesEvent>(_onGetServiceCategoriesEvent);
    on<GetServiceByServiceCategoryEvent>(_onGetServiceByServiceCategoryEvent);
  }

  Future<void> _onGetServiceCategoriesEvent(
    GetServiceCategoriesEvent event,
    Emitter<ServiceCategoryState> emit,
  ) async {
    emit(ServiceCategoryLoadingState());
    try {
      final response = await serviceCategoryRepository.getServiceCategories(
        search: event.search,
        orderBy: event.orderBy,
        page: event.page,
        size: event.size,
      );
      emit(ServiceCategorySuccessState(serviceCategories: response.items));
    } catch (e) {
      emit(ServiceCategoryErrorState(message: e.toString()));
    }
  }

  Future<void> _onGetServiceByServiceCategoryEvent(
    GetServiceByServiceCategoryEvent event,
    Emitter<ServiceCategoryState> emit,
  ) async {
    emit(ServiceCategoryLoadingState());
    try {
      final response =
          await serviceCategoryRepository.getServiceByServiceCategory(
        serviceCategoryId: event.serviceCategoryId,
        search: event.search,
        orderBy: event.orderBy,
        page: event.page,
        size: event.size,
      );
      emit(ServiceByCategorySuccessState(services: response.items));
    } catch (e) {
      emit(ServiceCategoryErrorState(message: e.toString()));
    }
  }
}
