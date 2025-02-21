
import '../../repositories/order_repository.dart';

class DeleteOrderFromLocal {
  final OrderRepository repository;

  DeleteOrderFromLocal(this.repository);

  Future<void> call() async {
    await repository.deleteOrderFromLocal();
  }
}