import 'package:dartz/dartz.dart';

import '../exception/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
