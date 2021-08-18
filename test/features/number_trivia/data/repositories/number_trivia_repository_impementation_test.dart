import 'package:dartz/dartz.dart';
import 'package:flutter_learn_architecture/core/platform/network_info.dart';
import 'package:flutter_learn_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_learn_architecture/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'package:flutter_learn_architecture/features/number_trivia/data/sources/number_trivia_local_source.dart';
import 'package:flutter_learn_architecture/features/number_trivia/data/sources/number_trivia_remote_source.dart';
import 'package:flutter_learn_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'number_trivia_repository_impementation_test.mocks.dart';

@GenerateMocks([
  NumberTriviaRemoteSource,
  NumberTriviaLocalSource,
  NetworkInfo,
])
void main() {
  final mockRemoteSource = MockNumberTriviaRemoteSource();
  final mockLocalSource = MockNumberTriviaLocalSource();
  final mockNetworkInfo = MockNetworkInfo();
  final repository = NumberTriviaRepositoryImplementation(
    remoteDataSource: mockRemoteSource,
    localDataSource: mockLocalSource,
    networkInfo: mockNetworkInfo,
  );

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'Test Text');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('check if device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() =>
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true));
      test('return remote data when call to remote source is successful',
          () async {
        //arrange
        when(mockRemoteSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteSource.getConcreteNumberTrivia(tNumber));
        expect(result, const Right(tNumberTrivia));
      });
    });
    group('device is offline', () {
      setUp(() =>
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false));
    });
  });
}
