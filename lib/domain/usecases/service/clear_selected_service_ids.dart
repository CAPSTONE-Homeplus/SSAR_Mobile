
import 'package:home_clean/data/repositories/service/service_repository.dart';

class ClearSelectedServiceIds {
  final ServiceRepository repository;

  ClearSelectedServiceIds(this.repository);

  Future<void> call() async {
    return await repository.clearSelectedServiceIds();
  }
}
