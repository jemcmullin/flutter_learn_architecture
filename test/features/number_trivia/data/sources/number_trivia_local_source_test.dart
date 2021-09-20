import 'dart:convert';

import 'package:flutter_learn_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_learn_architecture/features/number_trivia/data/sources/number_trivia_local_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/fixture_reader.dart';
import './number_trivia_local_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main(List<String> args) {
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
      verify(mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
      expect(result, tNumberTriviaModel);
    });
  });
}
