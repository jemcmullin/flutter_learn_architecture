import 'package:dartz/dartz.dart';
import 'package:flutter_learn_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_learn_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_learn_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'get_concrete_number_trivia_test.mocks.dart';

// class MockNumberTriviaRepository extends Mock
//     implements NumberTriviaRepository {}

@GenerateMocks([NumberTriviaRepository])
void main() {
  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(text: 'test', number: 1);
  final mockNumberTriviaRepository = MockNumberTriviaRepository();
  final usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);

  test(
    'should get trivia for the input number from the repository',
    () async {
      //arrange
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(1))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      final result = await usecase(const Parameters(number: tNumber));
      // assert
      expect(result, const Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}