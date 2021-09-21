import 'dart:math';

import 'package:flutter_learn_architecture/core/util/input_converter.dart';
import 'package:flutter_learn_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_learn_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_learn_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import './number_trivia_bloc_test.mocks.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  final mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
  final mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
  final mockInputConverter = MockInputConverter();
  final bloc = NumberTriviaBloc(
    concrete: mockGetConcreteNumberTrivia,
    random: mockGetRandomNumberTrivia,
    inputConverter: mockInputConverter,
  );

  test('bloc initialState should be empty', () async {
    //assert
    expect(bloc.state, Empty());
  });
}
