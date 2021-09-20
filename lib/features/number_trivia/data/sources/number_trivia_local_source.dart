import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getlastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalSourceImplementation implements NumberTriviaLocalSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalSourceImplementation({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getlastNumberTrivia() {
    // TODO: implement getlastNumberTrivia
    throw UnimplementedError();
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    // TODO: implement cacheNumberTrivia
    throw UnimplementedError();
  }
}
