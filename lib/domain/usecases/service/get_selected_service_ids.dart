import 'package:home_clean/data/repositories/service/service_repository.dart';

class GetSelectedServiceIds {
  final ServiceRepository repository;

  GetSelectedServiceIds(this.repository);

  Future<List<String>?> call() async {
    return await repository.getSelectedServiceIds();
  }
}
