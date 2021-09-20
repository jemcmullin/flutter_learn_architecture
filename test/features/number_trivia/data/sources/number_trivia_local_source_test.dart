import 'dart:convert';

import 'package:flutter_learn_architecture/core/error/exceptions.dart';
import 'package:flutter_learn_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_learn_architecture/features/number_trivia/data/sources/number_trivia_local_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/fixture_reader.dart';
import './number_trivia_local_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  final mockSharedPreferences = MockSharedPreferences();
  final dataSource = NumberTriviaLocalSourceImplementation(
    sharedPreferences: mockSharedPreferences,
  );

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(fixtureReader('trivia_cached.json')));
    test(
        'should return NumberTrivia from SharedPreferences when exists in cache',
        () async {
      //arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixtureReader('trivia_cached.json'));
      //act
      final result = await dataSource.getlastNumberTrivia();
      //assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, tNumberTriviaModel);
    });

    test('should throw CacheException when does not exist in cache', () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final call = dataSource.getlastNumberTrivia; //not the call '()'
      //assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTrivaModel = NumberTriviaModel(number: 1, text: 'Test Text');
    test('should call SharedPreferences to cache data', () async {
      //arrange
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      //act
      dataSource.cacheNumberTrivia(tNumberTrivaModel);
      //assert
      final expectedJsonString = json.encode(tNumberTrivaModel.toJson());
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
