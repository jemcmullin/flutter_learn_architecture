import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'features/number_trivia/data/sources/number_trivia_local_source.dart';
import 'features/number_trivia/data/sources/number_trivia_remote_source.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

//Service Locator
final getIt = GetIt.instance;

void init() {
//Features
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
  // getIt.registerSingletonWithDependencies<NumberTriviaLocalSource>(
  //   () => NumberTriviaLocalSourceImplementation(sharedPreferences: getIt()),
  //   dependsOn: [SharedPreferences],
  // );

//Core
  //Util
  getIt.registerLazySingleton(() => InputConverter());
  //Network
  getIt.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImplementation(getIt()));

//External
  getIt.registerSingletonAsync<SharedPreferences>(
      () async => SharedPreferences.getInstance());
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton(() => InternetConnectionChecker());
}
