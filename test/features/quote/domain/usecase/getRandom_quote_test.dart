import 'package:dartz/dartz.dart';
import "package:flutter_test/flutter_test.dart";
import 'package:mockito/mockito.dart';
import 'package:myapp/feauters/quotes/domain/entities/quote.dart';
import 'package:myapp/feauters/quotes/domain/repo/quoterepo.dart';
import 'package:myapp/feauters/quotes/domain/usecase/getQuote.dart';
import 'package:myapp/feauters/quotes/domain/usecase/get_random_quote.dart';

class MockQuoterepo extends Mock implements QuoteRepo {}

void main() {
  late GetRandomQuote usecase;
  late MockQuoterepo mockQuoterepo;

  setUp(() {
    mockQuoterepo = MockQuoterepo();
    usecase = GetRandomQuote(mockQuoterepo);
  });

  final Quote quote = Quote(quote: "text", id: 23, author: "rajesh saharan");


  test("should get quotes from repo random", () async{

    when(mockQuoterepo.getRandomQuote()).thenAnswer((_) async => Right(quote));

     final result = await usecase(NoParams());
      // UseCase should simply return whatever was returned from the Repository
      expect(result, Right(quote));
      // Verify that the method has been called on the Repository
      verify(mockQuoterepo.getRandomQuote());
      // Only the above method should be called and nothing more.

    },
    );

  }



