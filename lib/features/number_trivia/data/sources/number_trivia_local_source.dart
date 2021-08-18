import 'package:flutter_learn_architecture/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getlastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}
