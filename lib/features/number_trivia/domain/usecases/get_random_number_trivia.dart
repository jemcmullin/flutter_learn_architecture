import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_learn_architecture/core/error/failures.dart';
import 'package:flutter_learn_architecture/core/usecases/usecase.dart';
import 'package:flutter_learn_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_learn_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements Usecase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams parameters) async {
    return await repository.getRandomNumberTrivia();
  }
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
