import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteSourceImplementation
    implements NumberTriviaRemoteSource {
  final http.Client client;

  NumberTriviaRemoteSourceImplementation({required this.client});

  static const _baseUrl = 'numbersapi.com';
  static const _urlHeaders = {'Content-Type': 'application/json'};

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final urlEndpoint = Uri.http(_baseUrl, number.toString());
    final response = await client.get(urlEndpoint, headers: _urlHeaders);
    return NumberTriviaModel.fromJson(json.decode(response.body));
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}
