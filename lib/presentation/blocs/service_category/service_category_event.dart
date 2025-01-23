abstract class ServiceCategoryEvent {}

class GetServiceCategoriesEvent extends ServiceCategoryEvent {
  final String search;
  final String orderBy;
  final int page;
  final int size;

  GetServiceCategoriesEvent(
      {required this.search,
      required this.orderBy,
      required this.page,
      required this.size});
}

class GetServiceByServiceCategoryEvent extends ServiceCategoryEvent {
  final String serviceCategoryId;
  final String search;
  final String orderBy;
  final int page;
  final int size;

  GetServiceByServiceCategoryEvent(
      {required this.serviceCategoryId,
      required this.search,
      required this.orderBy,
      required this.page,
      required this.size});
}
