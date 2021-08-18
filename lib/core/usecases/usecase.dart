import 'package:dartz/dartz.dart';

import '../error/failures.dart';

abstract class Usecase<Type, Parameters> {
  Future<Either<Failure, Type>> call(Parameters parameters);
}
