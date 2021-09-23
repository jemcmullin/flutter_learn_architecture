// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_learn_architecture/core/error/failures.dart';
import 'package:flutter_learn_architecture/core/usecases/usecase.dart';
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
  //kept in order to maintain older tests that work
  final bloc = NumberTriviaBloc(
    getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
    getRandomNumberTrivia: mockGetRandomNumberTrivia,
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

    void setupMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
    }

    void setupMockSuccessCase() {
      setupMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
    }

    test(
      'should call InputConverter with string',
      () async {
        //arrange
        setupMockSuccessCase();
        //act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        //assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Error] when input is invalid',
      setUp: () => when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure())),
      build: () => NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter,
      ),
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [Error(message: INVALID_INPUT_FAILURE_MESSAGE)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get data from concrete use case',
      setUp: () => setupMockSuccessCase(),
      build: () => NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter,
      ),
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
      verify: (_) {
        verify(
          mockGetConcreteNumberTrivia(Parameters(number: tNumberParsed)),
        );
      },
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit states [Loading, Loaded] when data success',
      setUp: () {
        setupMockSuccessCase();
      },
      build: () => NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter,
      ),
      act: (bloc) {
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => [
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit states [Loading, Error] when data fails',
      setUp: () {
        setupMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
      },
      build: () => NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter,
      ),
      act: (bloc) {
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => [
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit states [Loading, Error] with proper message when cache data fails',
      setUp: () {
        setupMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
      },
      build: () => NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter,
      ),
      act: (bloc) {
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => [
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });

  group('getTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setupMockSuccessCase() {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
    }

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get data from random use case',
      setUp: () => setupMockSuccessCase(),
      build: () => NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter,
      ),
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      verify: (_) {
        verify(
          mockGetRandomNumberTrivia(NoParams()),
        );
      },
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit states [Loading, Loaded] when data success',
      setUp: () {
        setupMockSuccessCase();
      },
      build: () => NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter,
      ),
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit states [Loading, Error] when data fails',
      setUp: () {
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => Left(ServerFailure()));
      },
      build: () => NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter,
      ),
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );
    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit states [Loading, Error] with proper message when cache data fails',
      setUp: () {
        when(mockGetRandomNumberTrivia(NoParams()))
            .thenAnswer((_) async => Left(CacheFailure()));
      },
      build: () => NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter,
      ),
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => [
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });
}
