abstract class ServiceCategoryEvent {}

class GetServiceCategoriesEvent extends ServiceCategoryEvent {
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  GetServiceCategoriesEvent(
      {this.search, this.orderBy, this.page, required this.size});
}

class GetServiceByServiceCategoryEvent extends ServiceCategoryEvent {
  final String serviceCategoryId;
  final String? search;
  final String? orderBy;
  final int? page;
  final int? size;

  GetServiceByServiceCategoryEvent(
      {required this.serviceCategoryId,
      this.search,
      this.orderBy,
      this.page,
      this.size});
}
