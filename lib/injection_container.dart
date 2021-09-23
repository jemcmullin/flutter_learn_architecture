import 'package:flutter_learn_architecture/core/network/network_info.dart';
import 'package:flutter_learn_architecture/core/util/input_converter.dart';
import 'package:flutter_learn_architecture/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'package:flutter_learn_architecture/features/number_trivia/data/sources/number_trivia_remote_source.dart';
import 'package:flutter_learn_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_learn_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_learn_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'features/number_trivia/data/sources/number_trivia_local_source.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';

//Service Locator
final getIt = GetIt.instance;

void init() {
  initFeatures();
  initCore();
  initExternal();
}

void initFeatures() {
  //Bloc
  getIt.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: getIt(),
      getRandomNumberTrivia: getIt(),
      inputConverter: getIt(),
    ),
  );

  //Use Cases
  getIt.registerLazySingleton(() => GetConcreteNumberTrivia(getIt()));
  getIt.registerLazySingleton(() => GetRandomNumberTrivia(getIt()));

  //Repository
  getIt.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImplementation(
      localDataSource: getIt(),
      networkInfo: getIt(),
      remoteDataSource: getIt(),
    ),
  );

  //Data Sources
  getIt.registerLazySingleton<NumberTriviaRemoteSource>(
    () => NumberTriviaRemoteSourceImplementation(client: getIt()),
  );
  getIt.registerLazySingleton<NumberTriviaLocalSource>(
    () => NumberTriviaLocalSourceImplementation(sharedPreferences: getIt()),
  );
}

void initCore() {
  //Util
  getIt.registerLazySingleton(() => InputConverter());
  //Network
  getIt.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImplementation(getIt()));
}

void initExternal() {
  getIt.registerLazySingletonAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance());
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => InternetConnectionChecker());
}
