import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/constant.dart';
import 'package:home_clean/domain/usecases/service_category/get_service_by_service_category_usecase.dart';
import 'package:home_clean/domain/usecases/service_category/get_service_categories_usecase.dart';
import 'package:home_clean/presentation/blocs/service_category/service_category_event.dart';
import 'package:home_clean/presentation/blocs/service_category/service_category_state.dart';

class ServiceCategoryBloc
    extends Bloc<ServiceCategoryEvent, ServiceCategoryState> {
  final GetServiceCategoriesUsecase getServiceCategories;
  final GetServiceByServiceCategoryUsecase getServiceByServiceCategory;

  ServiceCategoryBloc(
      {required this.getServiceCategories,
      required this.getServiceByServiceCategory})
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
      final response = await getServiceCategories.execute(
        event.search ?? '',
        event.orderBy ?? '',
        event.page ?? Constant.defaultPage,
        event.size ?? Constant.defaultSize,
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
      final response = await getServiceByServiceCategory.execute(
        event.serviceCategoryId,
        event.search,
        event.orderBy,
        event.page,
        event.size,
      );
      emit(ServiceByCategorySuccessState(services: response.items));
    } catch (e) {
      emit(ServiceCategoryErrorState(message: e.toString()));
    }
  }
}
