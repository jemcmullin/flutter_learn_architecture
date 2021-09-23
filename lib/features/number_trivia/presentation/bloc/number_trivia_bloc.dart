import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_learn_architecture/core/error/failures.dart';
import 'package:flutter_learn_architecture/core/usecases/usecase.dart';

import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input - '
    'The number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>(
      (event, emit) async {
        final inputEither = inputConverter.stringToUnsignedInteger(
          event.numberString,
        );
        inputEither.fold(
          (failure) {
            emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
          },
          (integer) async {
            emit(Loading());
            final eitherFailureOrTrivia =
                await getConcreteNumberTrivia(Parameters(number: integer));
            emit(eitherFailureOrTrivia.fold(
              (failure) => Error(message: _mapFailureToError(failure)),
              (trivia) => Loaded(trivia: trivia),
            ));
          },
        );
      },
    );
    on<GetTriviaForRandomNumber>(
      (event, emit) async {
        emit(Loading());
        final eitherFailureOrTrivia = await getRandomNumberTrivia(NoParams());
        emit(eitherFailureOrTrivia.fold(
          (failure) => Error(message: _mapFailureToError(failure)),
          (trivia) => Loaded(trivia: trivia),
        ));
      },
    );
  }

  String _mapFailureToError(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
