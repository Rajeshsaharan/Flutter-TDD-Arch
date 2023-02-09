import 'package:myapp/core/error/exception.dart';
import 'package:myapp/core/platform/NetworkInfo.dart';
import 'package:myapp/feauters/quotes/data/datasources/QuoteLocalDataSource.dart';
import 'package:myapp/feauters/quotes/data/datasources/QuoteRemoteDataSource.dart';
import 'package:myapp/feauters/quotes/data/model/QuoteModel.dart';
import 'package:myapp/feauters/quotes/domain/entities/quote.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:myapp/feauters/quotes/domain/repo/quoterepo.dart';

class QuoteRepoImpl implements QuoteRepo {
  final QuoteRemoteDataSource quoteRemoteDataSource;
  final QuoteLocalDataSource quoteLocalDataSource;
  final NetworkInfo networkInfo;

  QuoteRepoImpl(
      {required this.quoteRemoteDataSource,
      required this.quoteLocalDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, Quote>> getQuote(int number) async {
    return await _getQuotesType(() {
      return quoteRemoteDataSource.getQuote(number);
    });
  }

  @override
  Future<Either<Failure, Quote>> getRandomQuote() async {
    return await _getQuotesType(() {
      return quoteRemoteDataSource.getRandomQuote();
    });

    // TODO: implement getRandomQuote
  }

  Future<Either<Failure, Quote>> _getQuotesType(
      Future<QuoteModel> Function() get_Quote_or_random_function) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await get_Quote_or_random_function();
        quoteLocalDataSource.cacheQuote(result);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final result = await quoteLocalDataSource.getlastQuote();
        return Right(result);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
