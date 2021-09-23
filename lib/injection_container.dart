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
final sl = GetIt.instance;

void init() {
  initFeatures();
  initCore();
  initExternal();
}

void initFeatures() {
  //Bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl(),
    ),
  );

  //Use Cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImplementation(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  //Data Sources
  sl.registerLazySingleton<NumberTriviaRemoteSource>(
    () => NumberTriviaRemoteSourceImplementation(client: sl()),
  );
  sl.registerLazySingleton<NumberTriviaLocalSource>(
    () => NumberTriviaLocalSourceImplementation(sharedPreferences: sl()),
  );
}

void initCore() {
  //Util
  sl.registerLazySingleton(() => InputConverter());
  //Network
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImplementation(sl()));
}

void initExternal() {
  sl.registerLazySingletonAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
