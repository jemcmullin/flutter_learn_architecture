// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_learn_architecture/core/util/input_converter.dart';
import 'package:flutter_learn_architecture/features/number_trivia/domain/entities/number_trivia.dart';
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

  group('getTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');
    test(
      'should call InputConverter with string',
      () async {
        //arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        //act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        //assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );
    blocTest(
      'should emit [Error] when input is invalid',
      build: () {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        return bloc;
      },
      act: (NumberTriviaBloc bloc) =>
          bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [Error(message: INVALID_INPUT_FAILURE_MESSAGE)],
    );

    blocTest(
      'should get data from concrete use case',
      setUp: () {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
      },
      build: () => bloc,
      act: (NumberTriviaBloc bloc) =>
          bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      verify: (_) {
        verify(
          mockGetConcreteNumberTrivia(Parameters(number: tNumberParsed)),
        );
      },
    );
  });
}
