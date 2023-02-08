import 'package:dartz/dartz.dart'; //for functional programming
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/feauters/quotes/domain/entities/quote.dart';

abstract class QuoteRepo {
  Future<Either<Failure, Quote>> getQuote(int number);
  Future<Either<Failure, Quote>> getRandomQuote();

}
