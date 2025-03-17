import 'package:dartz/dartz.dart';
import 'package:home_clean/data/datasource/local/local_data_source.dart';

import '../../../core/exception/failure.dart';

class ClearAllDataUseCase {
  final LocalDataSource localDataSource;

  ClearAllDataUseCase({required this.localDataSource});

  Future<Either<Failure, void>> call() async {
    try {
      await localDataSource.clearAllData();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Lỗi hệ thống: ${e.toString()}'));
    }
  }
}
