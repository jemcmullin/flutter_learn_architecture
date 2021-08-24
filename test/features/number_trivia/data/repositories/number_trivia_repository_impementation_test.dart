import 'package:dartz/dartz.dart';
import 'package:flutter_learn_architecture/core/error/exceptions.dart';
import 'package:flutter_learn_architecture/core/error/failures.dart';
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

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() =>
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true));
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is online', () {
      setUp(() =>
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false));
      body();
    });
  }

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

    runTestsOnline(() {
      test('return remote data when call to remote source is successful',
          () async {
        //arrange
        when(mockRemoteSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteSource.getConcreteNumberTrivia(tNumber));
        expect(result, const Right(tNumberTrivia));
      });
      test('cache data locally when call to remote source is successful',
          () async {
        //arrange
        when(mockRemoteSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalSource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test('return server failure when call to remote source is unsuccessful',
          () async {
        //arrange
        reset(mockLocalSource);
        when(mockRemoteSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockRemoteSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalSource);
        expect(result, Left(ServerFailure()));
      });
    });
    runTestsOffline(() {
      test('return last local cache data when data is present', () async {
        //arrange
        reset(mockRemoteSource);
        when(mockLocalSource.getlastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(mockRemoteSource);
        verify(mockLocalSource.getlastNumberTrivia());
        expect(result, const Right(tNumberTrivia));
      });
      test('return CacheFailure when no cache data present', () async {
        //arrange
        reset(mockRemoteSource);
        when(mockLocalSource.getlastNumberTrivia()).thenThrow(CacheException());
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(mockRemoteSource);
        verify(mockLocalSource.getlastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });
  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 123, text: 'Test Text');
    const NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('check if device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      repository.getRandomNumberTrivia();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test('return remote data when call to remote source is successful',
          () async {
        //arrange
        when(mockRemoteSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verify(mockRemoteSource.getRandomNumberTrivia());
        expect(result, const Right(tNumberTrivia));
      });
      test('cache data locally when call to remote source is successful',
          () async {
        //arrange
        when(mockRemoteSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        await repository.getRandomNumberTrivia();
        //assert
        verify(mockRemoteSource.getRandomNumberTrivia());
        verify(mockLocalSource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test('return server failure when call to remote source is unsuccessful',
          () async {
        //arrange
        reset(mockLocalSource);
        when(mockRemoteSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verify(mockRemoteSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalSource);
        expect(result, Left(ServerFailure()));
      });
    });
    runTestsOffline(() {
      test('return last local cache data when data is present', () async {
        //arrange
        reset(mockRemoteSource);
        when(mockLocalSource.getlastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(mockRemoteSource);
        verify(mockLocalSource.getlastNumberTrivia());
        expect(result, const Right(tNumberTrivia));
      });
      test('return CacheFailure when no cache data present', () async {
        //arrange
        reset(mockRemoteSource);
        when(mockLocalSource.getlastNumberTrivia()).thenThrow(CacheException());
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verifyZeroInteractions(mockRemoteSource);
        verify(mockLocalSource.getlastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
