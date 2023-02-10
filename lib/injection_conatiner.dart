import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:myapp/core/platform/NetworkInfo.dart';
import 'package:myapp/core/useCase/usecase.dart';
import 'package:myapp/core/utils/InputConvertor.dart';
import 'package:myapp/feauters/quotes/data/datasources/QuoteLocalDataSource.dart';
import 'package:myapp/feauters/quotes/data/datasources/QuoteRemoteDataSource.dart';
import 'package:myapp/feauters/quotes/data/repo/QuoteRepoImpl.dart';
import 'package:myapp/feauters/quotes/domain/repo/quoterepo.dart';
import 'package:myapp/feauters/quotes/domain/usecase/getQuote.dart';
import 'package:myapp/feauters/quotes/domain/usecase/get_random_quote.dart';
import 'package:myapp/feauters/quotes/presentation/bloc/quote_block.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  //! feature specific

  //? bloc for Quotes
  sl.registerFactory(() =>
      QuoteBloc(getQuote: sl(), getRandomQuote: sl(), inputConvertor: sl()));

  //*use case
  sl.registerLazySingleton(() => GetQuote(sl()));
  sl.registerLazySingleton(() => GetRandomQuote(sl()));
  //* repo
  sl.registerLazySingleton<QuoteRepo>(() => QuoteRepoImpl(
        quoteLocalDataSource: sl(),
        quoteRemoteDataSource: sl(),
        networkInfo: sl(),
      ));
  //? data source

  sl.registerLazySingleton<QuoteRemoteDataSource>(
      () => QuoteRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<QuoteLocalDataSource>(
      () => QuoteLocalDataStorageImpl(sharedPreferences: sl()));
  //! core
  sl.registerLazySingleton(() => InputConvertor());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //!external
  final sharedprefrence = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedprefrence);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
