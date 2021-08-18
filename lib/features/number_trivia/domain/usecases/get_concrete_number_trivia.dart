import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements Usecase<NumberTrivia, Parameters> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Parameters parameters) async {
    return await repository.getConcreteNumberTrivia(parameters.number);
  }
}

class Parameters extends Equatable {
  final int number;

  const Parameters({required this.number});

  @override
  List<Object> get props => [number];
}
