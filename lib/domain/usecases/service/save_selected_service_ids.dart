import 'package:home_clean/data/repositories/service/service_repository.dart';

class SaveSelectedServiceIds {
  final ServiceRepository repository;

  SaveSelectedServiceIds(this.repository);

  Future<void> call(List<String> ids) async {
    return await repository.saveSelectedServiceIds(ids);
  }
}
