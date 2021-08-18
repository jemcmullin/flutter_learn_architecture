import 'dart:convert';

import 'package:flutter_learn_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_learn_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test('should be a subclass of NumberTrivia entity', () async {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJSON', () {
    test('should return a valid model when JSON number is integer', () async {
      //arange
      final Map<String, dynamic> jsonMap =
          json.decode(fixtureReader('trivia.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, tNumberTriviaModel);
    });
    test('should return a valid model when JSON number is double', () async {
      //arange
      final Map<String, dynamic> jsonMap =
          json.decode(fixtureReader('trivia_double.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJSON', () {
    test('should return a JSON map containing data', () async {
      //act
      final result = tNumberTriviaModel.toJson();
      //assert
      const expectedMap = {
        "text": "Test Text",
        "number": 1,
      };
      expect(result, expectedMap);
    });
  });
}
