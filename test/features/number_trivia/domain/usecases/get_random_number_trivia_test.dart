import 'package:dartz/dartz.dart';
import 'package:flutter_learn_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_learn_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_learn_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'get_random_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  const tNumberTrivia = NumberTrivia(text: 'test', number: 1);
  final mockNumberTriviaRepository = MockNumberTriviaRepository();
  final usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);

  test(
    'should get trivia from the repository',
    () async {
      //arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      final result = await usecase(NoParams());
      // assert
      expect(result, const Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
