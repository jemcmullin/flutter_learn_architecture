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

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) {
    // TODO: implement getConcreteNumberTrivia
    throw UnimplementedError();
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}
