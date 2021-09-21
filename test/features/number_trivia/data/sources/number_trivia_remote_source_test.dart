import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_learn_architecture/core/error/exceptions.dart';
import 'package:flutter_learn_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_learn_architecture/features/number_trivia/data/sources/number_trivia_remote_source.dart';
import './number_trivia_remote_source_test.mocks.dart';
import '../../../../fixtures/fixture_reader.dart';

@GenerateMocks([http.Client])
void main() {
  final mockHttpClient = MockHttpClient();
  final dataSource =
      NumberTriviaRemoteSourceImplementation(client: mockHttpClient);

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final urlEndpoint = Uri.http('numbersapi.com', tNumber.toString());
    const urlHeaders = {'Content-Type': 'application/json'};
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixtureReader('trivia.json')),
    );
    test('''should GET request on URL with number endpoint 
            and application/json header''', () async {
      //arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(fixtureReader('trivia.json'), 200));
      //act
      dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockHttpClient.get(urlEndpoint, headers: urlHeaders));
    });

    test('should return NumberTrivia when response status is 200', () async {
      //arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(fixtureReader('trivia.json'), 200));
      //act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result, tNumberTriviaModel);
    });

    test('should throw ServerException when response status not 200', () async {
      //arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('error', 404));
      //act
      final call = dataSource.getConcreteNumberTrivia;
      //assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });
}
