import '../../../domain/entities/service/service.dart';
import '../../../domain/entities/service_category/service_category.dart';

abstract class ServiceCategoryState {}

class ServiceCategoryInitialState extends ServiceCategoryState {}

class ServiceCategoryLoadingState extends ServiceCategoryState {}

class ServiceCategoryErrorState extends ServiceCategoryState {
  final String message;
  ServiceCategoryErrorState({required this.message});
}

// State cho ServiceCategory
class ServiceCategorySuccessState extends ServiceCategoryState {
  final List<ServiceCategory> serviceCategories;
  ServiceCategorySuccessState({required this.serviceCategories});
}

// State cho ServiceByCategory
class ServiceByCategorySuccessState extends ServiceCategoryState {
  final List<Service> services;
  ServiceByCategorySuccessState({required this.services});
}
