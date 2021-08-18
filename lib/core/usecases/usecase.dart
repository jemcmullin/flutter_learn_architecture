import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

abstract class Usecase<Type, Parameters> {
  Future<Either<Failure, Type>> call(Parameters parameters);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
