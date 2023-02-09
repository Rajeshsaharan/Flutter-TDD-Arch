import 'package:myapp/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:myapp/core/useCase/usecase.dart';
import 'package:myapp/feauters/quotes/domain/repo/quoterepo.dart';

import '../entities/quote.dart';

class GetRandomQuote implements Usecase<Quote, NoParams> {
  final QuoteRepo repo;

  GetRandomQuote(this.repo);

  @override
  Future<Either<Failure, Quote>> call(NoParams params)async {
    return await repo.getRandomQuote();

  }
}

class NoParams {
  
}
