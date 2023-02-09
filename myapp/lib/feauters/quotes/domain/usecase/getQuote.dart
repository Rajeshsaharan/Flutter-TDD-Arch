import 'package:dartz/dartz.dart';
import 'package:myapp/core/useCase/usecase.dart';
import 'package:myapp/feauters/quotes/domain/entities/quote.dart';
import 'package:myapp/feauters/quotes/domain/repo/quoterepo.dart';

import '../../../../core/error/failure.dart';

class GetQuote implements Usecase<Quote, int> {
  final QuoteRepo repo;
  
  GetQuote(this.repo);
  @override
  Future<Either<Failure, Quote>> call(int number) async {
    return await repo.getQuote(number);
  }
}
